#include <ros/ros.h>
#include <erp42_msgs/DriveCmd.h>

#include <cmath>

int main(int argc, char** argv) {
  ros::init(argc, argv, "platform_controller");
  ros::NodeHandle nh;
  
  ros::Publisher drive_pub = nh.advertise<erp42_msgs::DriveCmd>("/erp42_serial/drive", 1);
  
  double rate = 30.0;
  ros::Rate loop_rate(rate);

  double time = 0.0;
  double dt = 1.0 / rate;
  
  double amplitude = 20.0 / 2.0;
  double frequency = 0.1;
  double phase = 0.0;
  
  while (ros::ok()) {
    erp42_msgs::DriveCmd drive_msg;
    drive_msg.KPH = amplitude*std::sin(2 * M_PI * frequency * time + phase)+amplitude;
    
    drive_pub.publish(drive_msg);
    
    ROS_INFO("Time: %.2f, KPH: %u", time, drive_msg.KPH);

    time += dt;
    loop_rate.sleep();
  }
  return 0;
}
