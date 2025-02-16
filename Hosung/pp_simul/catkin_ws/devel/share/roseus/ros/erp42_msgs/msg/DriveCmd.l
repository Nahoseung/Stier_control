;; Auto-generated. Do not edit!


(when (boundp 'erp42_msgs::DriveCmd)
  (if (not (find-package "ERP42_MSGS"))
    (make-package "ERP42_MSGS"))
  (shadow 'DriveCmd (find-package "ERP42_MSGS")))
(unless (find-package "ERP42_MSGS::DRIVECMD")
  (make-package "ERP42_MSGS::DRIVECMD"))

(in-package "ROS")
;;//! \htmlinclude DriveCmd.msg.html


(defclass erp42_msgs::DriveCmd
  :super ros::object
  :slots (_KPH _Deg ))

(defmethod erp42_msgs::DriveCmd
  (:init
   (&key
    ((:KPH __KPH) 0.0)
    ((:Deg __Deg) 0.0)
    )
   (send-super :init)
   (setq _KPH (float __KPH))
   (setq _Deg (float __Deg))
   self)
  (:KPH
   (&optional __KPH)
   (if __KPH (setq _KPH __KPH)) _KPH)
  (:Deg
   (&optional __Deg)
   (if __Deg (setq _Deg __Deg)) _Deg)
  (:serialization-length
   ()
   (+
    ;; float32 _KPH
    4
    ;; float32 _Deg
    4
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _KPH
       (sys::poke _KPH (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _Deg
       (sys::poke _Deg (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _KPH
     (setq _KPH (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _Deg
     (setq _Deg (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;;
   self)
  )

(setf (get erp42_msgs::DriveCmd :md5sum-) "53c3fce15cc38e7376d7cdb3768313e0")
(setf (get erp42_msgs::DriveCmd :datatype-) "erp42_msgs/DriveCmd")
(setf (get erp42_msgs::DriveCmd :definition-)
      "########################################
# Messages
########################################
float32 KPH
float32 Deg
")



(provide :erp42_msgs/DriveCmd "53c3fce15cc38e7376d7cdb3768313e0")


