#include "ros/ros.h"
#include "std_msgs/Int32.h"
#include "std_msgs/Float32.h"
#include "geometry_msgs/PoseStamped.h"
// #include "ublox_msgs/NavPVT.h"
#include "erp42_msgs/DriveCmd.h"

#include <cmath>




erp42_msgs::DriveCmd drive_msg;
std_msgs::Float32 gps_speed;

const float PI_ = 3.141592653f;
const float L = 1.04; 
int cur_idx = 0, target_idx = 0, cnt = 0, fixed_speed = 10, once =1 ;
float speed = 0.0, cog = 0.0, dis = 0.0, Ld = 3.0;
float** rddf = nullptr;





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
}



void pure_pursuit(float x, float y) {
    float current_x = x;
    float current_y = y;
    float current_steer = 0;
    int base_idx = cur_idx;
    

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
    drive_msg.Deg = current_steer;
    drive_msg.KPH = fixed_speed;
}


void callback(const geometry_msgs::PoseStamped::ConstPtr& coordinate)
{
    float cur_x = coordinate->pose.position.x;
    float cur_y = coordinate->pose.position.y;
    near_idx(cur_x,cur_y);
    pure_pursuit(cur_x, cur_y);
}


// void gpsCallback(const ublox_msgs::NavPVT::ConstPtr& heading_msg)
// {
//     speed = heading_msg->gSpeed * 0.0036;
//     cog = heading_msg->heading * 1e-5;
//     cog = cog * PI_ / 180.0;

//     gps_speed.data = speed;
//     speed_pub.publish(gps_speed);
// }



int read_rddf() {

    // string filename(ros::package::getPath("stier") + "/paths/2024-10-19_10-03_semi_1.txt");  // test

    string filename(ros::package::getPath("stier") + "/paths/table/real_final_kcity.txt");  // semi

    //string filename(ros::package::getPath("stier") + "/paths/2024-10-27_14-11_final_2.txt");  // final

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

int main(int argc,char **argv)
{

    ros::init(argc,argv,"pp_node");
    ros::NodeHandle nh;
    ROS_INFO("hey im here");
    
    ros::Publisher drive_pub;
    ros::Publisher speed_pub;
    cnt=read_rddf();
    for (int i = 0; i < count; i++) {
        f >> x >> y ;
        rddf[i][0] = x;
        rddf[i][1] = y;

        ROS_INFO("pp Node : I got %d ",rddf[i][0]);
    }

    ros::Subscriber sub = nh.subscribe("utm", 1, callback);
    // ros::Subscriber gps_sub = nh.subscribe("/ublox_position_receiver/navpvt", 1, gpsCallback);


    drive_pub = nh.advertise<erp42_msgs::DriveCmd>("/erp42_serial/drive", 1);
    speed_pub = nh.advertise<std_msgs::Float32>("/gps_speed", 1);

    ros::Rate loop_rate(8);

    while(ros::ok())
    {
        ros::spinOnce();
        drive_pub.publish(drive_msg);
        loop_rate.sleep();
    }


    for (int i = 0; i < cnt; ++i) 
    {
    delete[] rddf[i];
    }

    delete[] rddf;
    return 0;
}