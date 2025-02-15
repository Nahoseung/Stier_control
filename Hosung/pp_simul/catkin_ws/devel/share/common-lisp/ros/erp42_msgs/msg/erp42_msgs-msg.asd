
(cl:in-package :asdf)

(defsystem "erp42_msgs-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "DriveCmd" :depends-on ("_package_DriveCmd"))
    (:file "_package_DriveCmd" :depends-on ("_package"))
    (:file "Utm" :depends-on ("_package_Utm"))
    (:file "_package_Utm" :depends-on ("_package"))
  ))