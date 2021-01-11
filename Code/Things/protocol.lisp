(in-package :sketchpad)

(defvar *solver* (cass:make-solver))
(defvar *time-scale* (/ 1.0 60))

(defclass entity () ())

(defgeneric pre-constraints (entity)
  (:method ((entity entity))))
(defgeneric add-constraints (entity))
(defgeneric post-constraints (entity)
  (:method ((entity entity))))
