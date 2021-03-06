(in-package :sketchpad)

(defclass spring (entity)
  ((point1 :initarg :point1 :reader point1)
   (point2 :initarg :point2 :reader point2)
   (relaxed-length :initarg :length :reader relaxed-length)
   (k :initarg :k :reader k)))

(defmethod add-constraints ((spring spring))
  (let* ((coordinate1 (position (point1 spring)))
         (coordinate2 (position (point2 spring)))
         (midpoint (coordinate* (coordinate+ coordinate1 coordinate2)
                                0.5))
         (current-length (distance (position (point1 spring))
                                   (position (point2 spring))))
         (change-in-length (- current-length (relaxed-length spring))))
    (push (coordinate* (coordinate- coordinate1 midpoint)
                       (* -1 change-in-length (k spring)))
          (forces (point1 spring)))
    (push (coordinate* (coordinate- coordinate2 midpoint)
                       (* -1 change-in-length (k spring)))
          (forces (point2 spring)))))
