; Auto-generated. Do not edit!


(cl:in-package erp42_msgs-msg)


;//! \htmlinclude Utm.msg.html

(cl:defclass <Utm> (roslisp-msg-protocol:ros-message)
  ((x
    :reader x
    :initarg :x
    :type cl:float
    :initform 0.0)
   (y
    :reader y
    :initarg :y
    :type cl:float
    :initform 0.0)
   (heading
    :reader heading
    :initarg :heading
    :type cl:float
    :initform 0.0))
)

(cl:defclass Utm (<Utm>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <Utm>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'Utm)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name erp42_msgs-msg:<Utm> is deprecated: use erp42_msgs-msg:Utm instead.")))

(cl:ensure-generic-function 'x-val :lambda-list '(m))
(cl:defmethod x-val ((m <Utm>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:x-val is deprecated.  Use erp42_msgs-msg:x instead.")
  (x m))

(cl:ensure-generic-function 'y-val :lambda-list '(m))
(cl:defmethod y-val ((m <Utm>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:y-val is deprecated.  Use erp42_msgs-msg:y instead.")
  (y m))

(cl:ensure-generic-function 'heading-val :lambda-list '(m))
(cl:defmethod heading-val ((m <Utm>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader erp42_msgs-msg:heading-val is deprecated.  Use erp42_msgs-msg:heading instead.")
  (heading m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <Utm>) ostream)
  "Serializes a message object of type '<Utm>"
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'x))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'y))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'heading))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <Utm>) istream)
  "Deserializes a message object of type '<Utm>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'x) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'y) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'heading) (roslisp-utils:decode-single-float-bits bits)))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<Utm>)))
  "Returns string type for a message object of type '<Utm>"
  "erp42_msgs/Utm")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'Utm)))
  "Returns string type for a message object of type 'Utm"
  "erp42_msgs/Utm")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<Utm>)))
  "Returns md5sum for a message object of type '<Utm>"
  "5833e31792a7e4dcbebcee30b7c23de8")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'Utm)))
  "Returns md5sum for a message object of type 'Utm"
  "5833e31792a7e4dcbebcee30b7c23de8")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<Utm>)))
  "Returns full string definition for message of type '<Utm>"
  (cl:format cl:nil "float32 x~%float32 y~%float32 heading~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'Utm)))
  "Returns full string definition for message of type 'Utm"
  (cl:format cl:nil "float32 x~%float32 y~%float32 heading~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <Utm>))
  (cl:+ 0
     4
     4
     4
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <Utm>))
  "Converts a ROS message object to a list"
  (cl:list 'Utm
    (cl:cons ':x (x msg))
    (cl:cons ':y (y msg))
    (cl:cons ':heading (heading msg))
))
