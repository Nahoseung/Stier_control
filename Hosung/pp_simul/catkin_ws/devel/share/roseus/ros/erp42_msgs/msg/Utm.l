;; Auto-generated. Do not edit!


(when (boundp 'erp42_msgs::Utm)
  (if (not (find-package "ERP42_MSGS"))
    (make-package "ERP42_MSGS"))
  (shadow 'Utm (find-package "ERP42_MSGS")))
(unless (find-package "ERP42_MSGS::UTM")
  (make-package "ERP42_MSGS::UTM"))

(in-package "ROS")
;;//! \htmlinclude Utm.msg.html


(defclass erp42_msgs::Utm
  :super ros::object
  :slots (_x _y _heading ))

(defmethod erp42_msgs::Utm
  (:init
   (&key
    ((:x __x) 0.0)
    ((:y __y) 0.0)
    ((:heading __heading) 0.0)
    )
   (send-super :init)
   (setq _x (float __x))
   (setq _y (float __y))
   (setq _heading (float __heading))
   self)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:heading
   (&optional __heading)
   (if __heading (setq _heading __heading)) _heading)
  (:serialization-length
   ()
   (+
    ;; float32 _x
    4
    ;; float32 _y
    4
    ;; float32 _heading
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _x
       (sys::poke _x (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _y
       (sys::poke _y (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _heading
       (sys::poke _heading (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _x
     (setq _x (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _y
     (setq _y (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _heading
     (setq _heading (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get erp42_msgs::Utm :md5sum-) "5833e31792a7e4dcbebcee30b7c23de8")
(setf (get erp42_msgs::Utm :datatype-) "erp42_msgs/Utm")
(setf (get erp42_msgs::Utm :definition-)
      "float32 x
float32 y
float32 heading

")



(provide :erp42_msgs/Utm "5833e31792a7e4dcbebcee30b7c23de8")


