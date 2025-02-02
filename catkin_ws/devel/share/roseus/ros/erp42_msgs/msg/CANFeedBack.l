;; Auto-generated. Do not edit!


(when (boundp 'erp42_msgs::CANFeedBack)
  (if (not (find-package "ERP42_MSGS"))
    (make-package "ERP42_MSGS"))
  (shadow 'CANFeedBack (find-package "ERP42_MSGS")))
(unless (find-package "ERP42_MSGS::CANFEEDBACK")
  (make-package "ERP42_MSGS::CANFEEDBACK"))

(in-package "ROS")
;;//! \htmlinclude CANFeedBack.msg.html


(defclass erp42_msgs::CANFeedBack
  :super ros::object
  :slots (_MorA _EStop _Gear _speed _steer _brake _alive _encoder _brake_cmd_raw _brake_raw _brake_echo _brake_init_max ))

(defmethod erp42_msgs::CANFeedBack
  (:init
   (&key
    ((:MorA __MorA) 0)
    ((:EStop __EStop) 0)
    ((:Gear __Gear) 0)
    ((:speed __speed) 0.0)
    ((:steer __steer) 0.0)
    ((:brake __brake) 0)
    ((:alive __alive) 0)
    ((:encoder __encoder) 0)
    ((:brake_cmd_raw __brake_cmd_raw) 0)
    ((:brake_raw __brake_raw) 0)
    ((:brake_echo __brake_echo) 0)
    ((:brake_init_max __brake_init_max) 0)
    )
   (send-super :init)
   (setq _MorA (round __MorA))
   (setq _EStop (round __EStop))
   (setq _Gear (round __Gear))
   (setq _speed (float __speed))
   (setq _steer (float __steer))
   (setq _brake (round __brake))
   (setq _alive (round __alive))
   (setq _encoder (round __encoder))
   (setq _brake_cmd_raw (round __brake_cmd_raw))
   (setq _brake_raw (round __brake_raw))
   (setq _brake_echo (round __brake_echo))
   (setq _brake_init_max (round __brake_init_max))
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
  (:speed
   (&optional __speed)
   (if __speed (setq _speed __speed)) _speed)
  (:steer
   (&optional __steer)
   (if __steer (setq _steer __steer)) _steer)
  (:brake
   (&optional __brake)
   (if __brake (setq _brake __brake)) _brake)
  (:alive
   (&optional __alive)
   (if __alive (setq _alive __alive)) _alive)
  (:encoder
   (&optional __encoder)
   (if __encoder (setq _encoder __encoder)) _encoder)
  (:brake_cmd_raw
   (&optional __brake_cmd_raw)
   (if __brake_cmd_raw (setq _brake_cmd_raw __brake_cmd_raw)) _brake_cmd_raw)
  (:brake_raw
   (&optional __brake_raw)
   (if __brake_raw (setq _brake_raw __brake_raw)) _brake_raw)
  (:brake_echo
   (&optional __brake_echo)
   (if __brake_echo (setq _brake_echo __brake_echo)) _brake_echo)
  (:brake_init_max
   (&optional __brake_init_max)
   (if __brake_init_max (setq _brake_init_max __brake_init_max)) _brake_init_max)
  (:serialization-length
   ()
   (+
    ;; uint8 _MorA
    1
    ;; uint8 _EStop
    1
    ;; uint8 _Gear
    1
    ;; float64 _speed
    8
    ;; float64 _steer
    8
    ;; uint8 _brake
    1
    ;; uint8 _alive
    1
    ;; int32 _encoder
    4
    ;; uint8 _brake_cmd_raw
    1
    ;; uint8 _brake_raw
    1
    ;; uint8 _brake_echo
    1
    ;; uint8 _brake_init_max
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
     ;; float64 _speed
       (sys::poke _speed (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _steer
       (sys::poke _steer (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; uint8 _brake
       (write-byte _brake s)
     ;; uint8 _alive
       (write-byte _alive s)
     ;; int32 _encoder
       (write-long _encoder s)
     ;; uint8 _brake_cmd_raw
       (write-byte _brake_cmd_raw s)
     ;; uint8 _brake_raw
       (write-byte _brake_raw s)
     ;; uint8 _brake_echo
       (write-byte _brake_echo s)
     ;; uint8 _brake_init_max
       (write-byte _brake_init_max s)
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
   ;; float64 _speed
     (setq _speed (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _steer
     (setq _steer (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; uint8 _brake
     (setq _brake (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _alive
     (setq _alive (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; int32 _encoder
     (setq _encoder (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint8 _brake_cmd_raw
     (setq _brake_cmd_raw (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _brake_raw
     (setq _brake_raw (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _brake_echo
     (setq _brake_echo (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;; uint8 _brake_init_max
     (setq _brake_init_max (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;;
   self)
  )

(setf (get erp42_msgs::CANFeedBack :md5sum-) "8d74d0371fb1f42def9619b2296ec65d")
(setf (get erp42_msgs::CANFeedBack :datatype-) "erp42_msgs/CANFeedBack")
(setf (get erp42_msgs::CANFeedBack :definition-)
      "########################################
# Messages
########################################
uint8 MorA
uint8 EStop
uint8 Gear
float64 speed
float64 steer
uint8 brake
uint8 alive

int32 encoder
uint8 brake_cmd_raw
uint8 brake_raw
uint8 brake_echo
uint8 brake_init_max


")



(provide :erp42_msgs/CANFeedBack "8d74d0371fb1f42def9619b2296ec65d")


