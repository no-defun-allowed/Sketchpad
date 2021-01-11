(in-package :sketchpad)

(define-sketchpad-app-command (com-add-point :name t)
    ((x 'real :prompt "x")
     (y 'real :prompt "y")
     (mass 'real :prompt "Mass"))
  (push (make-instance 'point :position (make-coordinate :x x :y y) :mass mass)
        (entities clim:*application-frame*)))

(define-sketchpad-app-command (com-step :name t)
    ((frames 'integer :default 1 :prompt "Frames"))
  (dotimes (n frames)
    (step-frame clim:*application-frame*))
  (let ((pane (scene-pane clim:*application-frame*)))
    (setf (clim:pane-needs-redisplay pane) t)
    (clim:redisplay-frame-pane clim:*application-frame* pane :force-p t)
    (clim:repaint-sheet pane clim:+everywhere+)))

(define-sketchpad-app-command (com-add-weight :name t)
    ((point 'point :prompt t)
     (mass 'real :default 10.0 :prompt "Mass"))
  (push (make-instance 'weight :mass mass :point point)
        (entities clim:*application-frame*)))

(define-sketchpad-app-command (com-add-spring :name t)
  ((point-1 'point :prompt "Point 1")
   (point-2 'point :prompt "Point 2")
   (k 'real :default 10 :prompt "k constant"))
  (push (make-instance 'spring
                       :k k
                       :point1 point-1
                       :point2 point-2
                       :length (distance (position point-1) (position point-2)))
        (entities clim:*application-frame*)))

(define-sketchpad-app-command (com-simulate :name t)
    ()
  (let ((pane (scene-pane clim:*application-frame*)))
    (clim-internals::schedule-event pane
                                    (make-instance 'clim:timer-event
                                                   :token 'redraw-timer
                                                   :sheet pane)
                                    0.02)))
