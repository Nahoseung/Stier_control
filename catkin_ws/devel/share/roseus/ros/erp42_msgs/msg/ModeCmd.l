;; Auto-generated. Do not edit!


(when (boundp 'erp42_msgs::ModeCmd)
  (if (not (find-package "ERP42_MSGS"))
    (make-package "ERP42_MSGS"))
  (shadow 'ModeCmd (find-package "ERP42_MSGS")))
(unless (find-package "ERP42_MSGS::MODECMD")
  (make-package "ERP42_MSGS::MODECMD"))

(in-package "ROS")
;;//! \htmlinclude ModeCmd.msg.html


(defclass erp42_msgs::ModeCmd
  :super ros::object
  :slots (_MorA _EStop _Gear _alive ))

(defmethod erp42_msgs::ModeCmd
  (:init
   (&key
    ((:MorA __MorA) 0)
    ((:EStop __EStop) 0)
    ((:Gear __Gear) 0)
    ((:alive __alive) 0)
    )
   (send-super :init)
   (setq _MorA (round __MorA))
   (setq _EStop (round __EStop))
   (setq _Gear (round __Gear))
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
   ;; uint8 _alive
     (setq _alive (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;;
   self)
  )

(setf (get erp42_msgs::ModeCmd :md5sum-) "93db1f5d15225b4e964829a0cf6a3bdb")
(setf (get erp42_msgs::ModeCmd :datatype-) "erp42_msgs/ModeCmd")
(setf (get erp42_msgs::ModeCmd :definition-)
      "########################################
# Messages
########################################
uint8 MorA
uint8 EStop
uint8 Gear
uint8 alive

")



(provide :erp42_msgs/ModeCmd "93db1f5d15225b4e964829a0cf6a3bdb")


