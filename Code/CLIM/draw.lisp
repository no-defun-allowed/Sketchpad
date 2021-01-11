(in-package :sketchpad)

(defun point-position (point)
  (let ((position (position point)))
    (clim:make-point (coordinate-x position)
                     (coordinate-y position))))

(clim:define-presentation-method clim:present
    (object (type point) stream (view scene-view) &key)
  (clim:draw-circle stream
                    (point-position object)
                    5)
  (dolist (force (forces object))
    (let ((end-of-force-line (coordinate+ (coordinate* force (/ 0.1 (mass object)))
                                          (position object))))
      (clim:draw-arrow stream (point-position object)
                       (clim:make-point (coordinate-x end-of-force-line)
                                        (coordinate-y end-of-force-line))
                       :ink clim:+red+))))

(clim:define-presentation-method clim:present
    (object (type weight) stream (view scene-view) &key)
  (clim:draw-circle stream
                    (point-position (point object))
                    (mass object)
                    :filled nil
                    :line-thickness 2
                    :ink clim:+gray+))

(clim:define-presentation-method clim:present
    (object (type spring) stream (view scene-view) &key)
  (clim:draw-line stream
                  (point-position (point1 object))
                  (point-position (point2 object))
                  :line-thickness (/ (k object) 3)))
