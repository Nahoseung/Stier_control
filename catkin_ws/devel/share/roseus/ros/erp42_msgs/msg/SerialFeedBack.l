;; Auto-generated. Do not edit!


(when (boundp 'erp42_msgs::SerialFeedBack)
  (if (not (find-package "ERP42_MSGS"))
    (make-package "ERP42_MSGS"))
  (shadow 'SerialFeedBack (find-package "ERP42_MSGS")))
(unless (find-package "ERP42_MSGS::SERIALFEEDBACK")
  (make-package "ERP42_MSGS::SERIALFEEDBACK"))

(in-package "ROS")
;;//! \htmlinclude SerialFeedBack.msg.html


(defclass erp42_msgs::SerialFeedBack
  :super ros::object
  :slots (_MorA _EStop _Gear _speed _steer _brake _encoder _alive ))

(defmethod erp42_msgs::SerialFeedBack
  (:init
   (&key
    ((:MorA __MorA) 0)
    ((:EStop __EStop) 0)
    ((:Gear __Gear) 0)
    ((:speed __speed) 0.0)
    ((:steer __steer) 0.0)
    ((:brake __brake) 0)
    ((:encoder __encoder) 0)
    ((:alive __alive) 0)
    )
   (send-super :init)
   (setq _MorA (round __MorA))
   (setq _EStop (round __EStop))
   (setq _Gear (round __Gear))
   (setq _speed (float __speed))
   (setq _steer (float __steer))
   (setq _brake (round __brake))
   (setq _encoder (round __encoder))
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
  (:speed
   (&optional __speed)
   (if __speed (setq _speed __speed)) _speed)
  (:steer
   (&optional __steer)
   (if __steer (setq _steer __steer)) _steer)
  (:brake
   (&optional __brake)
   (if __brake (setq _brake __brake)) _brake)
  (:encoder
   (&optional __encoder)
   (if __encoder (setq _encoder __encoder)) _encoder)
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
    ;; float64 _speed
    8
    ;; float64 _steer
    8
    ;; int16 _brake
    2
    ;; int32 _encoder
    4
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
     ;; float64 _speed
       (sys::poke _speed (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; float64 _steer
       (sys::poke _steer (send s :buffer) (send s :count) :double) (incf (stream-count s) 8)
     ;; int16 _brake
       (write-word _brake s)
     ;; int32 _encoder
       (write-long _encoder s)
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
   ;; float64 _speed
     (setq _speed (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; float64 _steer
     (setq _steer (sys::peek buf ptr- :double)) (incf ptr- 8)
   ;; int16 _brake
     (setq _brake (sys::peek buf ptr- :short)) (incf ptr- 2)
   ;; int32 _encoder
     (setq _encoder (sys::peek buf ptr- :integer)) (incf ptr- 4)
   ;; uint8 _alive
     (setq _alive (sys::peek buf ptr- :char)) (incf ptr- 1)
   ;;
   self)
  )

(setf (get erp42_msgs::SerialFeedBack :md5sum-) "977be1b73fb4d99913310d68e9241255")
(setf (get erp42_msgs::SerialFeedBack :datatype-) "erp42_msgs/SerialFeedBack")
(setf (get erp42_msgs::SerialFeedBack :definition-)
      "########################################
# Messages
########################################
uint8 MorA
uint8 EStop
uint8 Gear
float64 speed
float64 steer
int16 brake
int32 encoder
uint8 alive

")



(provide :erp42_msgs/SerialFeedBack "977be1b73fb4d99913310d68e9241255")


