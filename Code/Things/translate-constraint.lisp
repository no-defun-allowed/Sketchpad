(in-package :sketchpad)

;;; Some stuff to translate constraints involving coordinates for Classowary.

(defun same (values)
  (every (alexandria:curry #'eql (first values))
         (rest values)))

(defun pull-x (value)
  (etypecase value
    ((or symbol number) value)
    (list (mapcar #'pull-x value))
    (coordinate (coordinate-x value))))
(defun pull-y (value)
  (etypecase value
    ((or symbol number) value)
    (list (mapcar #'pull-y value))
    (coordinate (coordinate-y value))))

(defgeneric translate-value/list (symbol values types)
  (:method ((+ (eql '+)) values types)
    (assert (>= (length values) 2))
    (assert (same types))
    (values `(+ ,@(mapcar #'translate-value values))
            (first types)))
  (:method ((* (eql '*)) values types)
    (assert (>= (length values) 2))
    (let ((coordinate-count (count 'coordinate types)))
      (assert (<= coordinate-count 1))
      (values `(* ,@(mapcar #'translate-value values))
              (if (zerop coordinate-count)
                  'scalar
                  'coordinate)))))

(defgeneric translate-value (constraint)
  (:method ((r real))       (values r 'scalar))
  (:method ((c coordinate)) (values c 'coordinate))
  (:method ((l list))
    (loop for value in (rest l)
          for (translated type) = (multiple-value-list
                                   (translate-value value))
          collect translated into values
          collect type into types
          finally (return
                    (translate-value/list (car l)
                                          values
                                          types)))))

(defun translate-constraint (constraint)
  (let* ((alist (loop for value in (rest constraint)
                      collecting (multiple-value-list
                                  (translate-value value))))
         (values (mapcar #'first alist))
         (types  (mapcar #'second alist)))
    (assert (same types))
    (ecase (first types)
      (scalar     `((= ,@values)))
      (coordinate `((= ,@(mapcar #'pull-x values))
                    (= ,@(mapcar #'pull-y values)))))))

(defmacro constrain (constraint)
  `(cass:constrain-with *solver* (translate-constraint ,constraint)))
