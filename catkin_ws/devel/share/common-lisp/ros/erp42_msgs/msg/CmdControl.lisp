; Auto-generated. Do not edit!


(cl:in-package erp42_msgs-msg)


;//! \htmlinclude CmdControl.msg.html

(cl:defclass <CmdControl> (roslisp-msg-protocol:ros-message)
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
   (KPH
    :reader KPH
    :initarg :KPH
    :type cl:fixnum
    :initform 0)
   (Deg
    :reader Deg
    :initarg :Deg
    :type cl:fixnum
    :initform 0)
   (brake
    :reader brake
    :initarg :brake
    :type cl:fixnum
    :initform 0)
   (alive
    :reader alive
    :initarg :alive
    :type cl:fixnum
    :initform 0))
)

(cl:defclass CmdControl (<CmdControl>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <CmdControl>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'CmdControl)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name erp42_msgs-msg:<CmdControl> is deprecated: use erp42_msgs-msg:CmdControl instead.")))

(cl:ensure-generic-function 'MorA-val :lambda-list '(m))
(cl:defmethod MorA-val ((m <CmdControl>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:MorA-val is deprecated.  Use erp42_msgs-msg:MorA instead.")
  (MorA m))

(cl:ensure-generic-function 'EStop-val :lambda-list '(m))
(cl:defmethod EStop-val ((m <CmdControl>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:EStop-val is deprecated.  Use erp42_msgs-msg:EStop instead.")
  (EStop m))

(cl:ensure-generic-function 'Gear-val :lambda-list '(m))
(cl:defmethod Gear-val ((m <CmdControl>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:Gear-val is deprecated.  Use erp42_msgs-msg:Gear instead.")
  (Gear m))

(cl:ensure-generic-function 'KPH-val :lambda-list '(m))
(cl:defmethod KPH-val ((m <CmdControl>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:KPH-val is deprecated.  Use erp42_msgs-msg:KPH instead.")
  (KPH m))

(cl:ensure-generic-function 'Deg-val :lambda-list '(m))
(cl:defmethod Deg-val ((m <CmdControl>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:Deg-val is deprecated.  Use erp42_msgs-msg:Deg instead.")
  (Deg m))

(cl:ensure-generic-function 'brake-val :lambda-list '(m))
(cl:defmethod brake-val ((m <CmdControl>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:brake-val is deprecated.  Use erp42_msgs-msg:brake instead.")
  (brake m))

(cl:ensure-generic-function 'alive-val :lambda-list '(m))
(cl:defmethod alive-val ((m <CmdControl>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:alive-val is deprecated.  Use erp42_msgs-msg:alive instead.")
  (alive m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <CmdControl>) ostream)
  "Serializes a message object of type '<CmdControl>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'MorA)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'EStop)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'Gear)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'KPH)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'KPH)) ostream)
  (cl:let* ((signed (cl:slot-value msg 'Deg)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'alive)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <CmdControl>) istream)
  "Deserializes a message object of type '<CmdControl>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'MorA)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'EStop)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'Gear)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'KPH)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'KPH)) (cl:read-byte istream))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'Deg) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'alive)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<CmdControl>)))
  "Returns string type for a message object of type '<CmdControl>"
  "erp42_msgs/CmdControl")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'CmdControl)))
  "Returns string type for a message object of type 'CmdControl"
  "erp42_msgs/CmdControl")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<CmdControl>)))
  "Returns md5sum for a message object of type '<CmdControl>"
  "17043bad9780a7db1065d8002634203b")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'CmdControl)))
  "Returns md5sum for a message object of type 'CmdControl"
  "17043bad9780a7db1065d8002634203b")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<CmdControl>)))
  "Returns full string definition for message of type '<CmdControl>"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%uint8 MorA~%uint8 EStop~%uint8 Gear~%uint16 KPH~%int16 Deg~%uint8 brake~%uint8 alive~%~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'CmdControl)))
  "Returns full string definition for message of type 'CmdControl"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%uint8 MorA~%uint8 EStop~%uint8 Gear~%uint16 KPH~%int16 Deg~%uint8 brake~%uint8 alive~%~%~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <CmdControl>))
  (cl:+ 0
     1
     1
     1
     2
     2
     1
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <CmdControl>))
  "Converts a ROS message object to a list"
  (cl:list 'CmdControl
    (cl:cons ':MorA (MorA msg))
    (cl:cons ':EStop (EStop msg))
    (cl:cons ':Gear (Gear msg))
    (cl:cons ':KPH (KPH msg))
    (cl:cons ':Deg (Deg msg))
    (cl:cons ':brake (brake msg))
    (cl:cons ':alive (alive msg))
))
