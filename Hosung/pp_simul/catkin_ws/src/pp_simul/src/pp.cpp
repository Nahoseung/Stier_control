#include <iostream>
#include <fstream>
#include <string>
#include <cmath>
// #include <algorithm>  // std::clamp 사용
#include "ros/package.h"
#include "ros/ros.h"
#include "std_msgs/Int32.h"
#include "std_msgs/Float32.h"
#include "geometry_msgs/PoseStamped.h"
#include "erp42_msgs/DriveCmd.h"
#include "erp42_msgs/Utm.h"

erp42_msgs::DriveCmd drive_msg;
std_msgs::Float32 gps_speed;

const float PI_ = 3.141592653f;
const float L = 1.04; 

int cur_idx = 0, target_idx = 0, cnt = 0, fixed_speed = 10, once = 1;
float speed = 0.0, cog = 0.0, dis = 0.0, Ld = 3.0;

double** rddf = nullptr;

void near_idx(float x, float y) {
    float minDist = 100000;
    int rangeStart = std::max(0, cur_idx - 30);
    int rangeEnd = std::min(cnt - 1, cur_idx + 50);

    if (once) {
        rangeStart = 0;
        rangeEnd = cnt;
        once = 0;
    }

    for (int i = rangeStart; i < rangeEnd; i++) {
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

    int rangeEnd = std::min(cnt - 1, cur_idx + 50);
    for (int i = cur_idx; i < rangeEnd; i++) {
        float dist = std::sqrt(std::pow(current_x - rddf[i][0], 2) + std::pow(current_y - rddf[i][1], 2));
        if (dist > Ld) {
            target_idx = i;
            dis = dist;
            break;
        }
    }

    float dx = rddf[target_idx][0] - current_x;
    float dy = rddf[target_idx][1] - current_y;
    float alpha = atan2(dx, dy);
    float temp_alpha = alpha - cog;

    if (cog > PI_ && cog <= 2 * PI_) temp_alpha += 2 * PI_;

    current_steer = atan2f(2.0f * L * sinf(temp_alpha) / dis, 1.0f);
    current_steer = current_steer * 180.0f / PI_;
    current_steer = current_steer * 1.4;
    // current_steer = std::clamp(current_steer, -28.169f, 28.169f);

    drive_msg.Deg = current_steer;
    drive_msg.KPH = fixed_speed;
}

void callback(const erp42_msgs::Utm::ConstPtr& msg) {
    float cur_x = msg->x;
    float cur_y = msg->y;
    near_idx(cur_x, cur_y);
    pure_pursuit(cur_x, cur_y);
}

int read_rddf() {
    std::string filename = ros::package::getPath("stier") + "/paths/real_final_kcity.txt";
    std::ifstream f(filename);
    double x = 0, y = 0;
    int count = 0;

    while (f >> x >> y) count++;
    f.close();

    rddf = new double*[count];
    for (int i = 0; i < count; ++i) rddf[i] = new double[2];

    f.open(filename);
    for (int i = 0; i < count; i++) {
        f >> rddf[i][0] >> rddf[i][1];
        // ROS_INFO("index %d : I got %f in x.",i, rddf[i][0]);
    }
    f.close();

    return count;
}

int main(int argc, char **argv) {
    ros::init(argc, argv, "pp_node");
    ros::NodeHandle nh;
    ros::Publisher drive_pub = nh.advertise<erp42_msgs::DriveCmd>("drive_cmd", 1);
    cnt = read_rddf();
    ROS_INFO("hey im here");

     

    ros::Subscriber sub = nh.subscribe("utm", 1, callback);
    ros::Rate loop_rate(8);

    while (ros::ok()) 
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
