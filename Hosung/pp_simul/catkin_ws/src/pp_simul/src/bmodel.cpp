#include <iostream>
#include <fstream>
#include <string>
#include <cmath>

#include "ros/package.h"
#include "ros/ros.h"
#include "std_msgs/Int32.h"
#include "std_msgs/Float32.h"
#include "geometry_msgs/PoseStamped.h"
#include "erp42_msgs/DriveCmd.h"
#include "erp42_msgs/Utm.h"


erp42_msgs::Utm utm_msg;
// ros::Publisher utm_pub;



// struct PredictedState {
//     float x;
//     float y;
//     float heading;  // 예측된 헤딩(방향)
//     // int idx;        // 예측된 인덱스
// };


const float PI_ = 3.141592653f;
const float L = 1.04; 

float current_x=0.0, current_y = 0.0, current_heading = 0.0, dt = 0.15f ; // dt: 예측 시간 (기존의 delay_time 대신 사용) 해당 모델에서도 dt가 필요한지는 의문. 

void predict_future_state(const erp42_msgs::DriveCmd::ConstPtr& msg) {
    float current_speed = msg->KPH;
    float current_steer = msg->Deg;

    ROS_INFO("im bmodel : Im got  %f , %f . ",current_steer, current_speed);

    // PredictedState result;
    
    // 자전거 모델 파라미터
    const float wheelbase = L;  // 축거 (이미 전역 변수로 선언된 L 사용)
    
    // 속도를 m/s로 변환
    float v = current_speed * (1000.0f / 3600.0f);
    
    // 조향각을 라디안으로 변환
    float steer_rad = (current_steer + 0.5f) * (PI_ / 180.0f); //feedback_steer를 current_steer로 변경. 
    
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
    utm_msg.x = current_x + (dt / 6.0f) * (k1_x + 2.0f * k2_x + 2.0f * k3_x + k4_x);
    utm_msg.y = current_y + (dt / 6.0f) * (k1_y + 2.0f * k2_y + 2.0f * k3_y + k4_y);
    utm_msg.heading = current_heading + (dt / 6.0f) * (k1_heading + 2.0f * k2_heading + 2.0f * k3_heading + k4_heading);
    
    ROS_INFO("im bmodel : I gonna publish  %f, %f in x,y. ", utm_msg.x, utm_msg.y);

}


int main(int argc, char** argv)
{
    ros::init(argc, argv, "bmodel_node");
    ros::NodeHandle nh;
    ros::Publisher utm_pub = nh.advertise<erp42_msgs::Utm>("utm",1);
    ros::Subscriber sub = nh.subscribe("drive_cmd",1,predict_future_state);



    ros::Rate loop_rate(0.1);

    utm_msg.x = 302454.91;
    utm_msg.y = 4123701.72;
    // if(ros::ok()) 
    // {
    //     utm_pub.publish(utm_msg);
    //     ROS_INFO("i do publish");
    // }

    while(ros::ok())
    {
        utm_pub.publish(utm_msg);
        ros::spinOnce();
        loop_rate.sleep();
    }

    return 0;

}
