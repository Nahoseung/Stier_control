; Auto-generated. Do not edit!


(cl:in-package erp42_msgs-msg)


;//! \htmlinclude SerialFeedBack.msg.html

(cl:defclass <SerialFeedBack> (roslisp-msg-protocol:ros-message)
  ((MorA
    :reader MorA
    :initarg :MorA
    :type cl:fixnum
    :initform 0)
   (EStop
    :reader EStop
    :initarg :EStop
    :type cl:fixnum
    :initform 0)
   (Gear
    :reader Gear
    :initarg :Gear
    :type cl:fixnum
    :initform 0)
   (speed
    :reader speed
    :initarg :speed
    :type cl:float
    :initform 0.0)
   (steer
    :reader steer
    :initarg :steer
    :type cl:float
    :initform 0.0)
   (brake
    :reader brake
    :initarg :brake
    :type cl:fixnum
    :initform 0)
   (encoder
    :reader encoder
    :initarg :encoder
    :type cl:integer
    :initform 0)
   (alive
    :reader alive
    :initarg :alive
    :type cl:fixnum
    :initform 0))
)

(cl:defclass SerialFeedBack (<SerialFeedBack>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <SerialFeedBack>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'SerialFeedBack)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name erp42_msgs-msg:<SerialFeedBack> is deprecated: use erp42_msgs-msg:SerialFeedBack instead.")))

(cl:ensure-generic-function 'MorA-val :lambda-list '(m))
(cl:defmethod MorA-val ((m <SerialFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:MorA-val is deprecated.  Use erp42_msgs-msg:MorA instead.")
  (MorA m))

(cl:ensure-generic-function 'EStop-val :lambda-list '(m))
(cl:defmethod EStop-val ((m <SerialFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:EStop-val is deprecated.  Use erp42_msgs-msg:EStop instead.")
  (EStop m))

(cl:ensure-generic-function 'Gear-val :lambda-list '(m))
(cl:defmethod Gear-val ((m <SerialFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:Gear-val is deprecated.  Use erp42_msgs-msg:Gear instead.")
  (Gear m))

(cl:ensure-generic-function 'speed-val :lambda-list '(m))
(cl:defmethod speed-val ((m <SerialFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:speed-val is deprecated.  Use erp42_msgs-msg:speed instead.")
  (speed m))

(cl:ensure-generic-function 'steer-val :lambda-list '(m))
(cl:defmethod steer-val ((m <SerialFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:steer-val is deprecated.  Use erp42_msgs-msg:steer instead.")
  (steer m))

(cl:ensure-generic-function 'brake-val :lambda-list '(m))
(cl:defmethod brake-val ((m <SerialFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:brake-val is deprecated.  Use erp42_msgs-msg:brake instead.")
  (brake m))

(cl:ensure-generic-function 'encoder-val :lambda-list '(m))
(cl:defmethod encoder-val ((m <SerialFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:encoder-val is deprecated.  Use erp42_msgs-msg:encoder instead.")
  (encoder m))

(cl:ensure-generic-function 'alive-val :lambda-list '(m))
(cl:defmethod alive-val ((m <SerialFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:alive-val is deprecated.  Use erp42_msgs-msg:alive instead.")
  (alive m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <SerialFeedBack>) ostream)
  "Serializes a message object of type '<SerialFeedBack>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'MorA)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'EStop)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'Gear)) ostream)
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'speed))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-double-float-bits (cl:slot-value msg 'steer))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 32) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 40) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 48) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 56) bits) ostream))
  (cl:let* ((signed (cl:slot-value msg 'brake)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
  (cl:let* ((signed (cl:slot-value msg 'encoder)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'alive)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <SerialFeedBack>) istream)
  "Deserializes a message object of type '<SerialFeedBack>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'MorA)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'EStop)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'Gear)) (cl:read-byte istream))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'speed) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 32) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 40) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 48) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 56) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'steer) (roslisp-utils:decode-double-float-bits bits)))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'brake) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'encoder) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'alive)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<SerialFeedBack>)))
  "Returns string type for a message object of type '<SerialFeedBack>"
  "erp42_msgs/SerialFeedBack")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'SerialFeedBack)))
  "Returns string type for a message object of type 'SerialFeedBack"
  "erp42_msgs/SerialFeedBack")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<SerialFeedBack>)))
  "Returns md5sum for a message object of type '<SerialFeedBack>"
  "977be1b73fb4d99913310d68e9241255")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'SerialFeedBack)))
  "Returns md5sum for a message object of type 'SerialFeedBack"
  "977be1b73fb4d99913310d68e9241255")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<SerialFeedBack>)))
  "Returns full string definition for message of type '<SerialFeedBack>"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%uint8 MorA~%uint8 EStop~%uint8 Gear~%float64 speed~%float64 steer~%int16 brake~%int32 encoder~%uint8 alive~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'SerialFeedBack)))
  "Returns full string definition for message of type 'SerialFeedBack"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%uint8 MorA~%uint8 EStop~%uint8 Gear~%float64 speed~%float64 steer~%int16 brake~%int32 encoder~%uint8 alive~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <SerialFeedBack>))
  (cl:+ 0
     1
     1
     1
     8
     8
     2
     4
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <SerialFeedBack>))
  "Converts a ROS message object to a list"
  (cl:list 'SerialFeedBack
    (cl:cons ':MorA (MorA msg))
    (cl:cons ':EStop (EStop msg))
    (cl:cons ':Gear (Gear msg))
    (cl:cons ':speed (speed msg))
    (cl:cons ':steer (steer msg))
    (cl:cons ':brake (brake msg))
    (cl:cons ':encoder (encoder msg))
    (cl:cons ':alive (alive msg))
))
