; Auto-generated. Do not edit!


(cl:in-package erp42_msgs-msg)


;//! \htmlinclude DriveCmd.msg.html

(cl:defclass <DriveCmd> (roslisp-msg-protocol:ros-message)
  ((KPH
    :reader KPH
    :initarg :KPH
    :type cl:float
    :initform 0.0)
   (Deg
    :reader Deg
    :initarg :Deg
    :type cl:float
    :initform 0.0))
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
(cl:defmethod roslisp-msg-protocol:serialize ((msg <DriveCmd>) ostream)
  "Serializes a message object of type '<DriveCmd>"
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'KPH))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'Deg))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <DriveCmd>) istream)
  "Deserializes a message object of type '<DriveCmd>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'KPH) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'Deg) (roslisp-utils:decode-single-float-bits bits)))
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
  "53c3fce15cc38e7376d7cdb3768313e0")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'DriveCmd)))
  "Returns md5sum for a message object of type 'DriveCmd"
  "53c3fce15cc38e7376d7cdb3768313e0")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<DriveCmd>)))
  "Returns full string definition for message of type '<DriveCmd>"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%float32 KPH~%float32 Deg~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'DriveCmd)))
  "Returns full string definition for message of type 'DriveCmd"
  (cl:format cl:nil "########################################~%# Messages~%########################################~%float32 KPH~%float32 Deg~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <DriveCmd>))
  (cl:+ 0
     4
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <DriveCmd>))
  "Converts a ROS message object to a list"
  (cl:list 'DriveCmd
    (cl:cons ':KPH (KPH msg))
    (cl:cons ':Deg (Deg msg))
))
