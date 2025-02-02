; Auto-generated. Do not edit!


(cl:in-package erp42_msgs-msg)


;//! \htmlinclude DriveCmd.msg.html

(cl:defclass <DriveCmd> (roslisp-msg-protocol:ros-message)
  ((KPH
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
    :initform 0))
)

(cl:defclass DriveCmd (<DriveCmd>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <DriveCmd>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'DriveCmd)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name erp42_msgs-msg:<DriveCmd> is deprecated: use erp42_msgs-msg:DriveCmd instead.")))

(cl:ensure-generic-function 'KPH-val :lambda-list '(m))
(cl:defmethod KPH-val ((m <DriveCmd>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:KPH-val is deprecated.  Use erp42_msgs-msg:KPH instead.")
  (KPH m))

(cl:ensure-generic-function 'Deg-val :lambda-list '(m))
(cl:defmethod Deg-val ((m <DriveCmd>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:Deg-val is deprecated.  Use erp42_msgs-msg:Deg instead.")
  (Deg m))

(cl:ensure-generic-function 'brake-val :lambda-list '(m))
(cl:defmethod brake-val ((m <DriveCmd>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:brake-val is deprecated.  Use erp42_msgs-msg:brake instead.")
  (brake m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <DriveCmd>) ostream)
  "Serializes a message object of type '<DriveCmd>"
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'KPH)) ostream)
  (cl:write-byte (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'KPH)) ostream)
  (cl:let* ((signed (cl:slot-value msg 'Deg)) (unsigned (cl:if (cl:< signed 0) (cl:+ signed 65536) signed)))
    (cl:write-byte (cl:ldb (cl:byte 8 0) unsigned) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) unsigned) ostream)
    )
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <DriveCmd>) istream)
  "Deserializes a message object of type '<DriveCmd>"
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'KPH)) (cl:read-byte istream))
    (cl:setf (cl:ldb (cl:byte 8 8) (cl:slot-value msg 'KPH)) (cl:read-byte istream))
    (cl:let ((unsigned 0))
      (cl:setf (cl:ldb (cl:byte 8 0) unsigned) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) unsigned) (cl:read-byte istream))
      (cl:setf (cl:slot-value msg 'Deg) (cl:if (cl:< unsigned 32768) unsigned (cl:- unsigned 65536))))
    (cl:setf (cl:ldb (cl:byte 8 0) (cl:slot-value msg 'brake)) (cl:read-byte istream))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<DriveCmd>)))
  "Returns string type for a message object of type '<DriveCmd>"
  "erp42_msgs/DriveCmd")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'DriveCmd)))
  "Returns string type for a message object of type 'DriveCmd"
  "erp42_msgs/DriveCmd")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<DriveCmd>)))
  "Returns md5sum for a message object of type '<DriveCmd>"
  "69a82c1e3ba067908d8fabb7e7d8716a")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'DriveCmd)))
  "Returns md5sum for a message object of type 'DriveCmd"
  "69a82c1e3ba067908d8fabb7e7d8716a")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<DriveCmd>)))
  "Returns full string definition for message of type '<DriveCmd>"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%uint16 KPH~%int16 Deg~%uint8 brake~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'DriveCmd)))
  "Returns full string definition for message of type 'DriveCmd"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%uint16 KPH~%int16 Deg~%uint8 brake~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <DriveCmd>))
  (cl:+ 0
     2
     2
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <DriveCmd>))
  "Converts a ROS message object to a list"
  (cl:list 'DriveCmd
    (cl:cons ':KPH (KPH msg))
    (cl:cons ':Deg (Deg msg))
    (cl:cons ':brake (brake msg))
))
