(in-package :sketchpad)

(defstruct coordinate
  (x 0)
  (y 0))

(defun coordinate+ (c1 c2)
  (make-coordinate :x (+ (coordinate-x c1) (coordinate-x c2))
                   :y (+ (coordinate-y c1) (coordinate-y c2))))

(defun coordinate* (c scalar)
  (make-coordinate :x (* (coordinate-x c) scalar)
                   :y (* (coordinate-y c) scalar)))

(defun coordinate- (c1 c2)
  (coordinate+ c1 (coordinate* c2 -1)))

(defun distance (c1 c2)
  (sqrt (+ (expt (- (coordinate-x c1) (coordinate-x c2)) 2)
           (expt (- (coordinate-y c1) (coordinate-y c2)) 2))))
