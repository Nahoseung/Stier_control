#include <fstream>
#include <string>
#include <ros/ros.h>
#include <geometry_msgs/PoseStamped.h>
#include <ctime>
#include <iostream>
#include <sstream>
#include <ros/package.h>
#include <cmath>
#include <erp42_msgs/DriveCmd.h>
#include <erp42_msgs/ModeCmd.h>
#include <std_msgs/Int32.h>
#include <std_msgs/Float32.h>
#include <std_msgs/Bool.h>
#include <ublox_msgs/NavPVT.h>
#include <erp42_msgs/SerialFeedBack.h>
#include <queue>
#include <iomanip>
#include <chrono>

using namespace std;
//this is for grduation
// Constants
const float PI_ = 3.141592653f;
const int MAX_BRAKE = 200;
const float MAX_SPEED_VISION = 20.0f;
const float MAX_SPEED_PUREPURSUIT = 20.0f;
const float MAX_SPEED_SLOW = 15.0f;
const float CONTROL_FREQUENCY = 8.0f;
const float CONTROL_PERIOD = 1.0f / CONTROL_FREQUENCY;

// Enums
enum class SectionType { 
    LANE_RRT = 1,  // 카메라 차선
    GPS_RRT = 2,
    TRAFFIC = 5,
    VISION = 10,
    INSIDE = 50,
    PURE_PURSUIT = 99  // 항법
};

// Global variables (consider encapsulating these in a class in future refactoring)
string ROS_HOME;
ofstream ff;

erp42_msgs::DriveCmd drive_msg;
erp42_msgs::ModeCmd mode_msg;
std_msgs::Int32 section;
std_msgs::Float32 gps_speed;
std_msgs::Int32 current_idx;
ros::Time start_, end_;
ros::Duration wait_;

ros::Publisher drive_pub;
ros::Publisher mode_pub;
ros::Publisher idx_pub;
ros::Publisher speed_pub; 
ros::Publisher current_idx_pub;

int delivery = 0;
int pp_state = 0;
float vision_deg = 0;
int obstacle_stop = 0;
int light_stop = 0;

// Pure pursuit variables
float** rddf = nullptr;
float Ld = 3, L = 1.04;
float dis = 0;
float cog = 0;
float speed = 0;
int target_idx = 0;
int cur_idx = 0;
int once = 1;
int cnt = 0;
float curvature = 0;

// Parking variables
int yacoder = 0, encoder = 0;
int park = 0;

// Steer & feedback
float cur_steer = 0;
float feedback_steer = 0;
float tmp_feedback_steer = 0;

// Delay compensation
float delay_time = 0.5;
float dist_idx = 0.4;
int delay_idx = 0;

int lidar_finish = 0;
std_msgs::Int32 stop_line;
int Auto = 0;

float predict_x = 0;
float predict_y = 0;
float target_vel = 0;

bool in_finish_transition = false;

// PID 제어를 위한 전역 변수
float integral = 0;
float prev_error = 0;
// 전역 변수에 브레이크 PID 제어를 위한 변수 추가
float brake_integral = 0;
float brake_prev_error = 0;

// encoder_speed 전역 변수
float encoder_speed = 0.0f;

int imsi = 0 ;

// Function declarations
void driving(float x, float y);
int read_rddf();
void near_idx(float x, float y);
void section_decide();
void pure_pursuit(float x, float y);
float calculate_curvature(float x1, float y1, float x2, float y2, float x3, float y3);
float calculate_adaptive_Ld(float speed, float curvature);
void aspeed(float target_speed, float current_speefd, float dt);
void handleTrafficMission(float x, float y);

struct PredictedState {
    float x;
    float y;
    float heading;  // 예측된 헤딩(방향)
    int idx;        // 예측된 인덱스
};

int predicted_index_diff = 0;
bool using_prediction = false;
float predict_dt = 0.15f;  // 예측 시간 (기존의 delay_time 대신 사용)

PredictedState predict_future_state(float current_x, float current_y, float current_speed, 
                                  float current_heading, float current_steer, float dt) {
    PredictedState result;
    
    // 자전거 모델 파라미터
    const float wheelbase = L;  // 축거 (이미 전역 변수로 선언된 L 사용)
    
    // 속도를 m/s로 변환
    float v = current_speed * (1000.0f / 3600.0f);
    
    // 조향각을 라디안으로 변환
    float steer_rad = (feedback_steer + 1.0f) * (PI_ / 180.0f);
    
    // 상태 방정식 계산 (자전거 모델)
    float beta = atan(0.5f * tan(steer_rad));  // 슬립각
    
    // Runge-Kutta 4차 적분
    float k1_x = v * cos(current_heading + beta);
    float k1_y = v * sin(current_heading + beta);
    float k1_heading = (v * cos(beta) * tan(steer_rad)) / wheelbase;

    float k2_x = v * cos(current_heading + beta + 0.5f * dt * k1_heading);
    float k2_y = v * sin(current_heading + beta + 0.5f * dt * k1_heading);
    float k2_heading = (v * cos(beta) * tan(steer_rad)) / wheelbase;

    float k3_x = v * cos(current_heading + beta + 0.5f * dt * k2_heading);
    float k3_y = v * sin(current_heading + beta + 0.5f * dt * k2_heading);
    float k3_heading = (v * cos(beta) * tan(steer_rad)) / wheelbase;

    float k4_x = v * cos(current_heading + beta + dt * k3_heading);
    float k4_y = v * sin(current_heading + beta + dt * k3_heading);
    float k4_heading = (v * cos(beta) * tan(steer_rad)) / wheelbase;

    // 최종 예측 상태 계산
    result.x = current_x + (dt / 6.0f) * (k1_x + 2.0f * k2_x + 2.0f * k3_x + k4_x);
    result.y = current_y + (dt / 6.0f) * (k1_y + 2.0f * k2_y + 2.0f * k3_y + k4_y);
    result.heading = current_heading + (dt / 6.0f) * (k1_heading + 2.0f * k2_heading + 2.0f * k3_heading + k4_heading);

    // 가장 가까운 경로 포인트 찾기
    float min_dist = std::numeric_limits<float>::max();
    result.idx = cur_idx;
    
    int search_start = std::max(0, cur_idx - 10);
    int search_end = std::min(cnt - 1, cur_idx + 50);
    
    for (int i = search_start; i < search_end; i++) {
        float dist = std::sqrt(std::pow(result.x - rddf[i][0], 2) + 
                             std::pow(result.y - rddf[i][1], 2));
        if (dist < min_dist) {
            min_dist = dist;
            result.idx = i;
        }
    }

    return result;
}

// driving 함수 수정
void driving(float x, float y) {

    near_idx(x, y);

    SectionType currentSection = static_cast<SectionType>(section.data);
    switch (currentSection) {
        case SectionType::GPS_RRT:
            break;
        case SectionType::LANE_RRT:
            break;
        case SectionType::VISION:
            break;
        case SectionType::TRAFFIC:
            handleTrafficMission(x, y);
            break;
        case SectionType::INSIDE:
            break;
        case SectionType::PURE_PURSUIT:
            pure_pursuit(x, y);
            break;
    }

    // if (obstacle_stop == 1 && section.data != 99) target_vel = 0;
    if ((obstacle_stop == 1 || light_stop == 1) && section.data == 50) target_vel = 0;

    aspeed(target_vel, speed, CONTROL_PERIOD);
}

float calculate_speed_control(float target_speed, float current_speed, float dt) {
    float kp = 4.0f;
    float ki = 0.5f;
    float kd = 0.05f;
    
    float error = target_speed - current_speed;
    
    integral += error * dt;
    integral = std::clamp(integral, -10.0f, 8.0f);
    
    float derivative = (error - prev_error) / dt;
    float output = kp * error + ki * integral + kd * derivative;
    
    prev_error = error;
    return std::clamp(output, -50.0f, 50.0f);
}

uint8_t calculate_brake_control(float speed_error, float dt, float current_speed) {
    // 속도에 따른 게인 조정
    float speed_ratio = current_speed / 25.0f;  // 최대속도로 정규화
    float error_ratio = min(abs(speed_error) / 25.0f, 1.0f);  // 오차 크기 정규화
    
    // 기본 게인값
    const float base_kp = 7.0f;
    const float base_ki = 0.1f;
    const float base_kd = 0.1f;
    
    // 적응형 게인 계산
    float brake_kp = base_kp * (1.0f + speed_ratio * 0.5f) * (1.0f + error_ratio * 0.3f);
    float brake_ki = base_ki * (1.0f - speed_ratio * 0.5f) * (1.0f - error_ratio * 0.5f);
    float brake_kd = base_kd * (1.0f + speed_ratio * 0.3f) * (1.0f + error_ratio * 0.2f);
    
    // anti-windup 범위도 속도에 따라 조정
    float max_integral = 500.0f * (1.0f + speed_ratio * 0.8f);
    
    brake_integral += speed_error * dt;
    brake_integral = std::clamp(brake_integral, 0.0f, max_integral);
    
    float brake_derivative = (speed_error - brake_prev_error) / dt;
    float brake_output = brake_kp * speed_error + 
                        brake_ki * brake_integral + 
                        brake_kd * brake_derivative;
    
    brake_prev_error = speed_error;

    // 최종 브레이크값 계산
    uint8_t final_brake = std::clamp(static_cast<int>(brake_output), 0, MAX_BRAKE);

    return final_brake;
}

void aspeed(float target_speed, float current_speed, float dt) {
    // 속도 제어
    // float speed_output = calculate_speed_control(target_speed, current_speed, dt);
    // float new_speed = std::clamp(current_speed + speed_output, 0.0f, 25.0f);
    
    // // 브레이크 제어
    // uint8_t brake_value = 0;
    // if (current_speed - target_speed > 0) {
    //     // 비선형 오차 계산
    //     double error = current_speed - target_speed;
        

    //     // 속도에 따른 추가 제동력 보정
    //     float speed_factor = 1.0f + (current_speed / 25.0f) * 0.5f;  // 고속에서 더 강한 제동
    //     error *= speed_factor;

    //     brake_value = calculate_brake_control(error, dt, current_speed);

    //     // 최소 브레이크 값 보장
    //     if (error > 1.0f && brake_value < 30) {
    //         brake_value = 30;  // 최소 브레이크 값 설정
    //     }
    // } else {
    //     brake_integral = 0;
    //     brake_prev_error = 0;
    // }
    
    // 최종 제어값 설정
    if (target_vel == 0) {
        drive_msg.KPH = 0;
        // drive_msg.brake = MAX_BRAKE;
    }
    else {
        drive_msg.KPH = target_vel;
        // drive_msg.brake = brake_value;
    }
    
    // 디버깅 출력
    // cout << "Speed PID - Error: " << (target_speed - current_speed) 
    //      << " Output: " << speed_output 
    //      << " Integral: " << integral << endl;
    // cout << "Brake PID - Value: " << (int)brake_value 
    //      << " Integral: " << brake_integral << endl;
    // cout << "_____________________" << endl;
}

int predict_future_idx(float current_speed, int current_idx) {
    // speed는 KPH 단위이므로 m/s로 변환
    float speed_ms = current_speed * (1000.0f / 3600.0f);
    
    // 0.05m 간격으로 된 경로에서 예측 거리만큼의 인덱스 계산
    int predicted_points = static_cast<int>(round(speed_ms * delay_time / 0.05f));
    
    // 예측된 인덱스가 배열 범위를 초과하지 않도록 제한
    return std::min(current_idx + predicted_points, cnt - 21);
}

float calculate_curvature(float x1, float y1, float x2, float y2, float x3, float y3) {
    float a = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
    float b = sqrt(pow(x3 - x2, 2) + pow(y3 - y2, 2));
    float c = sqrt(pow(x1 - x3, 2) + pow(y1 - y3, 2));
    float s = (a + b + c) / 2;
    float area = sqrt(s * (s - a) * (s - b) * (s - c));
    return 4 * area / (a * b * c);
}

float calculate_adaptive_Ld(float speed, float curvature) {
    const float base_ld = 0.0f;
    const float k_speed = 3.15f;
    const float k_curvature = 3.5f;
    const float min_ld = 3.0f;
    const float max_ld = 15.0f;

    float v = speed * 1000 / 3600;
    float ld_speed = base_ld + k_speed * pow(v, 0.7);
    float ld_curvature = max(0.0f, 1.0f - k_curvature * curvature);
    float ld = ld_speed * ld_curvature;

    return max(min_ld, min(ld, max_ld));
}


void pure_pursuit(float x, float y) {
    float current_x = x;
    float current_y = y;
    // float predicted_x = x;
    // float predicted_y = y;
    float current_steer = 0;
    // float predicted_steer = 0;
    int base_idx = cur_idx;
    // using_prediction = false;
    // predicted_index_diff = 0;
    

    // Ld = calculate_adaptive_Ld(speed, curvature); 3.0
    
    // 현재 위치에서의 조향각 계산
    {
        // 현재 위치 기준 타겟 포인트 찾기
        int rangeEnd = std::min(cnt - 1, cur_idx + 50);
        for (int i = cur_idx; i < rangeEnd; i++) {
            float dist = std::sqrt(std::pow(current_x - rddf[i][0], 2) + 
                                 std::pow(current_y - rddf[i][1], 2));
            if (dist > Ld) {
                target_idx = i;
                dis = dist;
                break;
            }
        }

        // 현재 위치 기준 조향각 계산
        float dx = rddf[target_idx][0] - current_x;
        float dy = rddf[target_idx][1] - current_y;
        float alpha = ((float(atan2(dx,dy))));
        float temp_alpha = (alpha - cog);
        if (cog > PI_ && cog <= 2 * PI_) temp_alpha += 2 * PI_;

        current_steer = atan2f(2.0f * L * sinf(temp_alpha) / (dis), 1.0f);
        current_steer = current_steer * 180.0f / PI_;
        current_steer = current_steer * 1.4;
        current_steer = std::clamp(current_steer, -28.169f, 28.169f);
    }



    // 최종 조향각 계산
    float final_steer = current_steer;

    // if (speed <= 1) final_steer = 0;
    final_steer = -1 * final_steer;
    final_steer = final_steer + 1;

    drive_msg.Deg = final_steer;
    mode_msg.Gear = 0x00;
}

void near_idx(float x, float y){
    float minDist = 100000;

    int rangeStart = max(0, cur_idx - 30);
    int rangeEnd = min(cnt - 1, cur_idx + 50);

    if (once){
        rangeStart = 0;
        rangeEnd = cnt;
        once=0;
    }

    for (int i = rangeStart ; i < rangeEnd; i++) {
        float dist = sqrt(pow(x - rddf[i][0], 2) + pow(y - rddf[i][1], 2));
            if (dist < minDist) {
                minDist = dist;
                cur_idx = i;
            }
    }

    section_decide();
}

void handleTrafficMission(float x, float y) {
    if (light_stop == 1)
        target_vel = 0;
    else {
        pure_pursuit(x, y);
        target_vel = 3*4;
    }
}

void section_decide() {
    section.data = 50;
    // target_vel = 4;

    // /* 서교초 */
    // if (cur_idx <= 32) section.data = 1;  
    // else if(cur_idx > 32 && cur_idx <= 85) section.data = 2;
    // else section.data = 1;

    /* 서강초 */
    // if (cur_idx <= 40) section.data = 2;
    // // else if (cur_idx > 30 && cur_idx <= 40) {
    // //     section.data = 99;
    // //     target_vel = 10;
    // // }
    // else if (cur_idx > 50 && cur_idx <= 55) section.data = 5;
    // // else if (cur_idx > ? && cur_idx <= ?) {
    // //     section.data = 99;
    // //     target_vel = 15;
    // // }
    // else section.data = 2;
}


/* Callback 함수들 */

void missionKPHCallback(const std_msgs::Float32::ConstPtr& msgs){
    if ((section.data == 1 || section.data == 2) && obstacle_stop == 0) {
        target_vel = static_cast<uint16_t>(msgs->data);
    }
}

void missionDegCallback(const std_msgs::Float32::ConstPtr& msgs){
    if (section.data == 1 || section.data == 2) {
        drive_msg.Deg = static_cast<int16_t>(msgs->data);
    }
}

void insideKPHCallback(const std_msgs::Float32::ConstPtr& msgs){
    if (section.data == 50 && obstacle_stop == 0 && light_stop == 0) {
        target_vel = static_cast<uint16_t>(msgs->data);
    }
}

void insideDegCallback(const std_msgs::Float32::ConstPtr& msgs){
    if (section.data == 50 && obstacle_stop == 0 && light_stop == 0) {
        drive_msg.Deg = static_cast<int16_t>(msgs->data);
    }
}

void visionDegCallback(const std_msgs::Float32::ConstPtr& msgs) {
    if (section.data == 10)
        drive_msg.Deg = static_cast<int16_t>(msgs->data);
}

void obstacleStopCallback(const std_msgs::Int32::ConstPtr& msgs) {
    obstacle_stop = msgs->data;
}

void lightStopCallback(const std_msgs::Int32::ConstPtr& msgs) {
    light_stop = msgs->data;
}

void gpsCallback(const ublox_msgs::NavPVT::ConstPtr& heading_msg)
{
    speed = heading_msg->gSpeed * 0.0036;
    cog = heading_msg->heading * 1e-5;
    cog = cog * PI_ / 180.0;

    gps_speed.data = speed;
    speed_pub.publish(gps_speed);
}

// void serialFeedback(const erp42_msgs::SerialFeedBack::ConstPtr& feedback_msg){
//     encoder = feedback_msg->encoder;
//     encoder_speed = feedback_msg->speed;
//     feedback_steer = feedback_msg->steer;
//     Auto = feedback_msg->MorA;
// }

void lidarFinishCallback(const std_msgs::Int32::ConstPtr& finish_msg) {
    if (finish_msg->data == 1) {
        lidar_finish = finish_msg->data;
        in_finish_transition = true;  // 플래그 설정
    }
}

void callback(const geometry_msgs::PoseStamped::ConstPtr& coordinate)
{
    float cur_x = coordinate->pose.position.x;
    float cur_y = coordinate->pose.position.y;
    
    // if (Auto == 1) {
        auto now = std::chrono::system_clock::now();
        auto now_ms = std::chrono::duration_cast<std::chrono::milliseconds>(now.time_since_epoch()).count() % 1000;
        auto now_c = std::chrono::system_clock::to_time_t(now);
        std::tm* now_tm = std::localtime(&now_c);

        ff << std::setfill('0') 
           << std::setw(2) << now_tm->tm_hour << ":"
           << std::setw(2) << now_tm->tm_min << ":"
           << std::setw(2) << now_tm->tm_sec << "."
           << std::setw(3) << now_ms << "\t"
           << coordinate->pose.position.x << "\t" << coordinate->pose.position.y << "\t"
           << cur_idx << "\t" << target_idx << "\t" << cnt << "\t" << section.data << "\t"
           << target_vel << "\t" << drive_msg.KPH << "\t" << speed << "\t" << (int)drive_msg.brake << "\t" 
           << drive_msg.Deg << "\t" << feedback_steer << "\t" << Ld << "\t" << curvature << "\t"
           << encoder_speed << "\t" << encoder << "\t"
           << predicted_index_diff << "\t" << (using_prediction ? 1 : 0) << "\t" << endl;  // 새로운 데이터 추가
    // }

    driving(cur_x, cur_y);
}

int read_rddf() {

    string filename(ros::package::getPath("stier") + "/paths/2024-11-20_17-59.txt");  // final

    ifstream f(filename);
    f.precision(12);
    cout.precision(12);
    float x = 0, y = 0;
    int count=0;

    while (!f.eof()) {
        f >> x >> y ;
        if (f.eof()) break;
        count++;
    }
    f.close();

    rddf = new float* [count];

    for (int i = 0; i < count; ++i) {
        rddf[i] = new float[2];
    }

    f.open(filename);
    for (int i = 0; i < count; i++) {
        f >> x >> y ;
        rddf[i][0] = x;
        rddf[i][1] = y;
    }
    f.close();

	return count;
}

int main(int argc, char** argv)
{
    ros::init(argc, argv, "pp");
    cnt=read_rddf();	

    ros::NodeHandle nh;
    ROS_HOME = ros::package::getPath("stier");
 
    time_t now = time(0);
    tm *ltm = localtime(&now);
   
    stringstream ss;

    ss << ROS_HOME << "/run_paths/"
    << setw(2) << setfill('0') << 1 + ltm->tm_mon
    << setw(2) << setfill('0') << ltm->tm_mday << "_"
    << setw(2) << setfill('0') << ltm->tm_hour
    << setw(2) << setfill('0') << ltm->tm_min << ".txt";

    ff.open(ss.str());
    ff << "Timestamp \t" << "cur_x \t" << "cur_y \t" << "cur_idx \t" << "target_idx \t" << "end_idx \t" << "section \t" 
       << "target_KPH \t" << "input_KPH \t" << "cur_KPH \t" << "input_brake \t" 
       << "target_Deg \t" << "cur_Deg \t" << "Ld \t"  << "Curvature \t" << "Encoder_KPH \t"  << "Encoder \t"
       << "predicted_idx_diff \t" << "using_prediction \t" << endl;  // 새로운 컬럼 추가
    ff.precision(12);

    ros::Subscriber sub = nh.subscribe("utm", 1, callback);
    ros::Subscriber gps_sub = nh.subscribe("/ublox_position_receiver/navpvt", 1, gpsCallback);
    // ros::Subscriber feedback_sub = nh.subscribe("/erp42_serial/feedback", 1, serialFeedback);
    ros::Subscriber lidar_sub1 = nh.subscribe("/missionKPH", 1, missionKPHCallback);
    ros::Subscriber lidar_sub2 = nh.subscribe("/missionDeg", 1, missionDegCallback);   
    ros::Subscriber inside_sub1 = nh.subscribe("/insideKPH", 1, insideKPHCallback);
    ros::Subscriber inside_sub2 = nh.subscribe("/insideDeg", 1, insideDegCallback);
    ros::Subscriber lidar_finish = nh.subscribe("/avoid_finish", 1, lidarFinishCallback);
    ros::Subscriber cuv= nh.subscribe("/visionDeg", 1, visionDegCallback);
    ros::Subscriber obstacle_stop = nh.subscribe("/obstacle_stop", 1, obstacleStopCallback);
    ros::Subscriber light_stop = nh.subscribe("/light_stop", 1, lightStopCallback);

    drive_pub = nh.advertise<erp42_msgs::DriveCmd>("/erp42_serial/drive", 1);
    mode_pub = nh.advertise<erp42_msgs::ModeCmd>("/erp42_serial/mode", 1);
    idx_pub = nh.advertise<std_msgs::Int32>("/section", 1);
    speed_pub = nh.advertise<std_msgs::Float32>("/gps_speed", 1); 
    current_idx_pub = nh.advertise<std_msgs::Int32>("/current_idx", 1);

    ros::Rate loop_rate(8);

    mode_msg.MorA = 0x01;
    mode_msg.EStop = 0x00;

    while (ros::ok()){
        mode_pub.publish(mode_msg);
        drive_pub.publish(drive_msg);
        idx_pub.publish(section);
        driving(0.0, 0.0);
       
        cout << "cur_idx = " << cur_idx << "   tar_idx = " << target_idx << "   end_idx = " << cnt << endl;
        cout << "delay_idx = " << delay_idx + cur_idx << "   섹션 = " << section.data << endl;
        cout << "target_KPH = " << target_vel << "  input_KPH = " << drive_msg.KPH << "  current_KPH = " <<  fixed << setprecision(2) << speed << endl;
        cout << "Brake = " << (int)drive_msg.brake << "  Deg = " << drive_msg.Deg  << "  curvature = " << curvature  << "  Ld = " << fixed << setprecision(2) << Ld << endl;
        
        // 예측 관련 정보 출력 추가
        if (using_prediction) {
            cout << "Using Prediction: Yes  Index Difference: " << predicted_index_diff << endl;
        } else {
            cout << "Using Prediction: No" << endl;
        }
        
        cout << "_____________________" << endl;

        current_idx.data = cur_idx; 
        current_idx_pub.publish(current_idx);

        ros::spinOnce();
        loop_rate.sleep();
    }            

    ff.close();

    for (int i = 0; i < cnt; ++i) {
        delete[] rddf[i];
    }
    delete[] rddf;

    return 0;
}