#include "ros/ros.h"
#include "std_msgs/Float32.h"


int main(int argc, char **argv){
    float temp=10.0;
    ros::init(argc,argv,"pp_publisher");
    ros::NodeHandle nh;

    ros::Publisher steer_pub = nh.advertise<std_msgs::Float32>("steer",10);
    ros::Publisher speed_pub = nh.advertise<std_msgs::Float32>("speed",10);

    ros::Rate loop_rate(0.1);

    while(ros::ok()){
        std_msgs::Float32 steer_msg;
        std_msgs::Float32 speed_msg;
        
        steer_msg.data = temp;
        speed_msg.data = 5.0;

        steer_pub.publish(steer_msg);
        speed_pub.publish(speed_msg);

        ROS_INFO("Published steer: %f, speed %f", steer_msg.data, speed_msg.data);
        temp++;
        ros::spinOnce();
        loop_rate.sleep();
    }

    return 0;
}
