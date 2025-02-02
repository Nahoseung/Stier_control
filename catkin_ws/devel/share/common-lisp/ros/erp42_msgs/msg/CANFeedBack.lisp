; Auto-generated. Do not edit!


(cl:in-package erp42_msgs-msg)


;//! \htmlinclude CANFeedBack.msg.html

(cl:defclass <CANFeedBack> (roslisp-msg-protocol:ros-message)
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
   (alive
    :reader alive
    :initarg :alive
    :type cl:fixnum
    :initform 0)
   (encoder
    :reader encoder
    :initarg :encoder
    :type cl:integer
    :initform 0)
   (brake_cmd_raw
    :reader brake_cmd_raw
    :initarg :brake_cmd_raw
    :type cl:fixnum
    :initform 0)
   (brake_raw
    :reader brake_raw
    :initarg :brake_raw
    :type cl:fixnum
    :initform 0)
   (brake_echo
    :reader brake_echo
    :initarg :brake_echo
    :type cl:fixnum
    :initform 0)
   (brake_init_max
    :reader brake_init_max
    :initarg :brake_init_max
    :type cl:fixnum
    :initform 0))
)

(cl:defclass CANFeedBack (<CANFeedBack>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CANFeedBack>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CANFeedBack)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name erp42_msgs-msg:<CANFeedBack> is deprecated: use erp42_msgs-msg:CANFeedBack instead.")))

(cl:ensure-generic-function 'MorA-val :lambda-list '(m))
(cl:defmethod MorA-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:MorA-val is deprecated.  Use erp42_msgs-msg:MorA instead.")
  (MorA m))

(cl:ensure-generic-function 'EStop-val :lambda-list '(m))
(cl:defmethod EStop-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:EStop-val is deprecated.  Use erp42_msgs-msg:EStop instead.")
  (EStop m))

(cl:ensure-generic-function 'Gear-val :lambda-list '(m))
(cl:defmethod Gear-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:Gear-val is deprecated.  Use erp42_msgs-msg:Gear instead.")
  (Gear m))

(cl:ensure-generic-function 'speed-val :lambda-list '(m))
(cl:defmethod speed-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:speed-val is deprecated.  Use erp42_msgs-msg:speed instead.")
  (speed m))

(cl:ensure-generic-function 'steer-val :lambda-list '(m))
(cl:defmethod steer-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:steer-val is deprecated.  Use erp42_msgs-msg:steer instead.")
  (steer m))

(cl:ensure-generic-function 'brake-val :lambda-list '(m))
(cl:defmethod brake-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:brake-val is deprecated.  Use erp42_msgs-msg:brake instead.")
  (brake m))

(cl:ensure-generic-function 'alive-val :lambda-list '(m))
(cl:defmethod alive-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:alive-val is deprecated.  Use erp42_msgs-msg:alive instead.")
  (alive m))

(cl:ensure-generic-function 'encoder-val :lambda-list '(m))
(cl:defmethod encoder-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:encoder-val is deprecated.  Use erp42_msgs-msg:encoder instead.")
  (encoder m))

(cl:ensure-generic-function 'brake_cmd_raw-val :lambda-list '(m))
(cl:defmethod brake_cmd_raw-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:brake_cmd_raw-val is deprecated.  Use erp42_msgs-msg:brake_cmd_raw instead.")
  (brake_cmd_raw m))

(cl:ensure-generic-function 'brake_raw-val :lambda-list '(m))
(cl:defmethod brake_raw-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:brake_raw-val is deprecated.  Use erp42_msgs-msg:brake_raw instead.")
  (brake_raw m))

(cl:ensure-generic-function 'brake_echo-val :lambda-list '(m))
(cl:defmethod brake_echo-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:brake_echo-val is deprecated.  Use erp42_msgs-msg:brake_echo instead.")
  (brake_echo m))

(cl:ensure-generic-function 'brake_init_max-val :lambda-list '(m))
(cl:defmethod brake_init_max-val ((m <CANFeedBack>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:brake_init_max-val is deprecated.  Use erp42_msgs-msg:brake_init_max instead.")
  (brake_init_max m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CANFeedBack>) ostream)
  "Serializes a message object of type '<CANFeedBack>"
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
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'alive)) ostream)
  (cl:let* ((signed (cl:slot-value msg 'encoder)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 4294967296) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake_cmd_raw)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake_raw)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake_echo)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake_init_max)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CANFeedBack>) istream)
  "Deserializes a message object of type '<CANFeedBack>"
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
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'alive)) (cl:read-byte istream))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'encoder) (cl:if (cl:< unsigned 2147483648) unsigned (cl:- unsigned 4294967296))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake_cmd_raw)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake_raw)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake_echo)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake_init_max)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CANFeedBack>)))
  "Returns string type for a message object of type '<CANFeedBack>"
  "erp42_msgs/CANFeedBack")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CANFeedBack)))
  "Returns string type for a message object of type 'CANFeedBack"
  "erp42_msgs/CANFeedBack")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CANFeedBack>)))
  "Returns md5sum for a message object of type '<CANFeedBack>"
  "8d74d0371fb1f42def9619b2296ec65d")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CANFeedBack)))
  "Returns md5sum for a message object of type 'CANFeedBack"
  "8d74d0371fb1f42def9619b2296ec65d")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CANFeedBack>)))
  "Returns full string definition for message of type '<CANFeedBack>"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%uint8 MorA~%uint8 EStop~%uint8 Gear~%float64 speed~%float64 steer~%uint8 brake~%uint8 alive~%~%int32 encoder~%uint8 brake_cmd_raw~%uint8 brake_raw~%uint8 brake_echo~%uint8 brake_init_max~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CANFeedBack)))
  "Returns full string definition for message of type 'CANFeedBack"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%uint8 MorA~%uint8 EStop~%uint8 Gear~%float64 speed~%float64 steer~%uint8 brake~%uint8 alive~%~%int32 encoder~%uint8 brake_cmd_raw~%uint8 brake_raw~%uint8 brake_echo~%uint8 brake_init_max~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CANFeedBack>))
  (cl:+ 0
     1
     1
     1
     8
     8
     1
     1
     4
     1
     1
     1
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CANFeedBack>))
  "Converts a ROS message object to a list"
  (cl:list 'CANFeedBack
    (cl:cons ':MorA (MorA msg))
    (cl:cons ':EStop (EStop msg))
    (cl:cons ':Gear (Gear msg))
    (cl:cons ':speed (speed msg))
    (cl:cons ':steer (steer msg))
    (cl:cons ':brake (brake msg))
    (cl:cons ':alive (alive msg))
    (cl:cons ':encoder (encoder msg))
    (cl:cons ':brake_cmd_raw (brake_cmd_raw msg))
    (cl:cons ':brake_raw (brake_raw msg))
    (cl:cons ':brake_echo (brake_echo msg))
    (cl:cons ':brake_init_max (brake_init_max msg))
))
