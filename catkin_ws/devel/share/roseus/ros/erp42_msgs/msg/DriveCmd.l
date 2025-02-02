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
  :slots (_KPH _Deg _brake ))

(defmethod erp42_msgs::DriveCmd
  (:init
   (&key
    ((:KPH __KPH) 0)
    ((:Deg __Deg) 0)
    ((:brake __brake) 0)
    )
   (send-super :init)
   (setq _KPH (round __KPH))
   (setq _Deg (round __Deg))
   (setq _brake (round __brake))
   self)
  (:KPH
   (&optional __KPH)
   (if __KPH (setq _KPH __KPH)) _KPH)
  (:Deg
   (&optional __Deg)
   (if __Deg (setq _Deg __Deg)) _Deg)
  (:brake
   (&optional __brake)
   (if __brake (setq _brake __brake)) _brake)
  (:serialization-length
   ()
   (+
    ;; uint16 _KPH
    2
    ;; int16 _Deg
    2
    ;; uint8 _brake
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint16 _KPH
       (write-word _KPH s)
     ;; int16 _Deg
       (write-word _Deg s)
     ;; uint8 _brake
       (write-byte _brake s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint16 _KPH
     (setq _KPH (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; int16 _Deg
     (setq _Deg (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; uint8 _brake
     (setq _brake (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;;
   self)
  )

(setf (get erp42_msgs::DriveCmd :md5sum-) "69a82c1e3ba067908d8fabb7e7d8716a")
(setf (get erp42_msgs::DriveCmd :datatype-) "erp42_msgs/DriveCmd")
(setf (get erp42_msgs::DriveCmd :definition-)
      "########################################
# Messages
########################################
uint16 KPH
int16 Deg
uint8 brake

")



(provide :erp42_msgs/DriveCmd "69a82c1e3ba067908d8fabb7e7d8716a")


