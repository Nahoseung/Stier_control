; Auto-generated. Do not edit!


(cl:in-package erp42_msgs-msg)


;//! \htmlinclude ModeCmd.msg.html

(cl:defclass <ModeCmd> (roslisp-msg-protocol:ros-message)
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
   (alive
    :reader alive
    :initarg :alive
    :type cl:fixnum
    :initform 0))
)

(cl:defclass ModeCmd (<ModeCmd>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <ModeCmd>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'ModeCmd)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name erp42_msgs-msg:<ModeCmd> is deprecated: use erp42_msgs-msg:ModeCmd instead.")))

(cl:ensure-generic-function 'MorA-val :lambda-list '(m))
(cl:defmethod MorA-val ((m <ModeCmd>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:MorA-val is deprecated.  Use erp42_msgs-msg:MorA instead.")
  (MorA m))

(cl:ensure-generic-function 'EStop-val :lambda-list '(m))
(cl:defmethod EStop-val ((m <ModeCmd>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:EStop-val is deprecated.  Use erp42_msgs-msg:EStop instead.")
  (EStop m))

(cl:ensure-generic-function 'Gear-val :lambda-list '(m))
(cl:defmethod Gear-val ((m <ModeCmd>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:Gear-val is deprecated.  Use erp42_msgs-msg:Gear instead.")
  (Gear m))

(cl:ensure-generic-function 'alive-val :lambda-list '(m))
(cl:defmethod alive-val ((m <ModeCmd>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:alive-val is deprecated.  Use erp42_msgs-msg:alive instead.")
  (alive m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <ModeCmd>) ostream)
  "Serializes a message object of type '<ModeCmd>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'MorA)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'EStop)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'Gear)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'alive)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <ModeCmd>) istream)
  "Deserializes a message object of type '<ModeCmd>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'MorA)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'EStop)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'Gear)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'alive)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<ModeCmd>)))
  "Returns string type for a message object of type '<ModeCmd>"
  "erp42_msgs/ModeCmd")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'ModeCmd)))
  "Returns string type for a message object of type 'ModeCmd"
  "erp42_msgs/ModeCmd")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<ModeCmd>)))
  "Returns md5sum for a message object of type '<ModeCmd>"
  "93db1f5d15225b4e964829a0cf6a3bdb")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'ModeCmd)))
  "Returns md5sum for a message object of type 'ModeCmd"
  "93db1f5d15225b4e964829a0cf6a3bdb")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<ModeCmd>)))
  "Returns full string definition for message of type '<ModeCmd>"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%uint8 MorA~%uint8 EStop~%uint8 Gear~%uint8 alive~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'ModeCmd)))
  "Returns full string definition for message of type 'ModeCmd"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%uint8 MorA~%uint8 EStop~%uint8 Gear~%uint8 alive~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <ModeCmd>))
  (cl:+ 0
     1
     1
     1
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <ModeCmd>))
  "Converts a ROS message object to a list"
  (cl:list 'ModeCmd
    (cl:cons ':MorA (MorA msg))
    (cl:cons ':EStop (EStop msg))
    (cl:cons ':Gear (Gear msg))
    (cl:cons ':alive (alive msg))
))
