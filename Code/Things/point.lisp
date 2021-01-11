(in-package :sketchpad)

(defclass point (entity)
  ((position     :initarg :position
                 :initform (make-coordinate)   :accessor position)
   (velocity     :initform (make-coordinate)   :accessor velocity)
   (mass         :initarg :mass :initform 1.0  :reader mass)
   (forces       :initform '()                 :accessor forces)))

(defmethod pre-constraints ((point point))
  (setf (forces point) '()))

(defmethod add-constraints ((point point)))

(defmethod post-constraints ((point point))
  (let ((acceleration (coordinate* (reduce #'coordinate+ (forces point)
                                           :initial-value (make-coordinate))
                                   (/ (mass point)))))
    (setf (velocity point) (coordinate+
                            (coordinate* acceleration *time-scale*)
                            (velocity point))
          (position point) (coordinate+
                            (coordinate* (velocity point) *time-scale*)
                            (position point)))))
