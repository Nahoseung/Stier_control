;; Auto-generated. Do not edit!


(when (boundp 'erp42_msgs::CmdControl)
  (if (not (find-package "ERP42_MSGS"))
    (make-package "ERP42_MSGS"))
  (shadow 'CmdControl (find-package "ERP42_MSGS")))
(unless (find-package "ERP42_MSGS::CMDCONTROL")
  (make-package "ERP42_MSGS::CMDCONTROL"))

(in-package "ROS")
;;//! \htmlinclude CmdControl.msg.html


(defclass erp42_msgs::CmdControl
  :super ros::object
  :slots (_MorA _EStop _Gear _KPH _Deg _brake _alive ))

(defmethod erp42_msgs::CmdControl
  (:init
   (&key
    ((:MorA __MorA) 0)
    ((:EStop __EStop) 0)
    ((:Gear __Gear) 0)
    ((:KPH __KPH) 0)
    ((:Deg __Deg) 0)
    ((:brake __brake) 0)
    ((:alive __alive) 0)
    )
   (send-super :init)
   (setq _MorA (round __MorA))
   (setq _EStop (round __EStop))
   (setq _Gear (round __Gear))
   (setq _KPH (round __KPH))
   (setq _Deg (round __Deg))
   (setq _brake (round __brake))
   (setq _alive (round __alive))
   self)
  (:MorA
   (&optional __MorA)
   (if __MorA (setq _MorA __MorA)) _MorA)
  (:EStop
   (&optional __EStop)
   (if __EStop (setq _EStop __EStop)) _EStop)
  (:Gear
   (&optional __Gear)
   (if __Gear (setq _Gear __Gear)) _Gear)
  (:KPH
   (&optional __KPH)
   (if __KPH (setq _KPH __KPH)) _KPH)
  (:Deg
   (&optional __Deg)
   (if __Deg (setq _Deg __Deg)) _Deg)
  (:brake
   (&optional __brake)
   (if __brake (setq _brake __brake)) _brake)
  (:alive
   (&optional __alive)
   (if __alive (setq _alive __alive)) _alive)
  (:serialization-length
   ()
   (+
    ;; uint8 _MorA
    1
    ;; uint8 _EStop
    1
    ;; uint8 _Gear
    1
    ;; uint16 _KPH
    2
    ;; int16 _Deg
    2
    ;; uint8 _brake
    1
    ;; uint8 _alive
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; uint8 _MorA
       (write-byte _MorA s)
     ;; uint8 _EStop
       (write-byte _EStop s)
     ;; uint8 _Gear
       (write-byte _Gear s)
     ;; uint16 _KPH
       (write-word _KPH s)
     ;; int16 _Deg
       (write-word _Deg s)
     ;; uint8 _brake
       (write-byte _brake s)
     ;; uint8 _alive
       (write-byte _alive s)
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; uint8 _MorA
     (setq _MorA (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _EStop
     (setq _EStop (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _Gear
     (setq _Gear (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint16 _KPH
     (setq _KPH (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; int16 _Deg
     (setq _Deg (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; uint8 _brake
     (setq _brake (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _alive
     (setq _alive (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;;
   self)
  )

(setf (get erp42_msgs::CmdControl :md5sum-) "17043bad9780a7db1065d8002634203b")
(setf (get erp42_msgs::CmdControl :datatype-) "erp42_msgs/CmdControl")
(setf (get erp42_msgs::CmdControl :definition-)
      "########################################
# Messages
########################################
uint8 MorA
uint8 EStop
uint8 Gear
uint16 KPH
int16 Deg
uint8 brake
uint8 alive



")



(provide :erp42_msgs/CmdControl "17043bad9780a7db1065d8002634203b")


