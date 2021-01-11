(in-package :sketchpad)

(defvar *gravity* (make-coordinate :x 0 :y -98.1))

(defclass weight (entity)
  ((point :initarg :point :reader point)
   (mass  :initarg :mass :initform 1.0 :reader mass)))

(defmethod add-constraints ((weight weight))
  (push (coordinate* *gravity* (mass weight))
        (forces (point weight))))
