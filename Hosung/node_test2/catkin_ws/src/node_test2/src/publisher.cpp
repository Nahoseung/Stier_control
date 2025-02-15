#include "ros/ros.h"
#include "std_msgs/Int32.h"

#include <cstdlib>
#include <ctime>


int main(int argc, char **argv)
{
    ros::init(argc,argv, "publisher_ndoe");
    ros::NodeHandle nh;
    ros::Publisher pub = nh.advertise<std_msgs::Int32>("ascii_int",10);

    ros::Rate loop_rate(0.1);
    std::srand(std::time(0));

    while(ros::ok())
    {
        std_msgs::Int32 msg;
        int temp = std::rand();
        temp = 97 + ( temp % 26); //scope to alphabet ascii 
        ROS_INFO("publisher Node : I Publish %d ",temp);
        msg.data = temp;
        pub.publish(msg);

        ros::spinOnce();
        loop_rate.sleep();
    }
    return 0;
}