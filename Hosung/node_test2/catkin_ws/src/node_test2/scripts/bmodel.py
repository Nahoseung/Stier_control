#! /usr/bin/env python3

import rospy
from std_msgs.msg import Int32

def lowertoupper_callback(data):
    rospy.loginfo("Bmodel Node : I subscribe %c &", data.data)
    upper_case = (data.data - 32) # lower to upper alphabet.

    bmodel_pub.publish(upper_case)
    rospy.loginfo("Bmodel Node : I publish %c \n ", upper_case)



rospy.init_node('bmodel_node')
rospy.Subscriber('lowercase',Int32,lowertoupper_callback)
bmodel_pub = rospy.Publisher('uppercase',Int32, queue_size = 10)

rospy.spin()
