
(cl:in-package :asdf)

(defsystem "erp42_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "CANFeedBack" :depends-on ("_package_CANFeedBack"))
    (:file "_package_CANFeedBack" :depends-on ("_package"))
    (:file "CmdControl" :depends-on ("_package_CmdControl"))
    (:file "_package_CmdControl" :depends-on ("_package"))
    (:file "DriveCmd" :depends-on ("_package_DriveCmd"))
    (:file "_package_DriveCmd" :depends-on ("_package"))
    (:file "ModeCmd" :depends-on ("_package_ModeCmd"))
    (:file "_package_ModeCmd" :depends-on ("_package"))
    (:file "SerialFeedBack" :depends-on ("_package_SerialFeedBack"))
    (:file "_package_SerialFeedBack" :depends-on ("_package"))
  ))