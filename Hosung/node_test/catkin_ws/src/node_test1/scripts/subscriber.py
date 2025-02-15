#!/usr/bin/env python3

import rospy
from std_msgs.msg import Float32

def steer_callback(data):
    rospy.loginfo("Received steer: %f", data.data)
    


def speed_callback(data):
    rospy.loginfo("Received speed: %f", data.data)

def listener():
    rospy.init_node('subscriber', anonymous=True)
    rospy.Subscriber('steer',Float32,steer_callback)
    rospy.Subscriber('speed',Float32,speed_callback)

    rospy.spin()

if __name__ == '__main__':
    listener()