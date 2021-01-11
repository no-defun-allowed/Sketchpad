(in-package :sketchpad)

(defclass scene-view (clim:view)
  ())

(defclass scene-pane (clim:application-pane)
  ())

(clim:define-application-frame sketchpad-app ()
  ((entities :initform '() :accessor entities)
   (scene-pane :reader scene-pane))
  (:panes
   (scene scene-pane
          :height 600 :width 600
          :max-height 1000
          :default-view (make-instance 'scene-view)
          :display-function 'draw-scene
          :scroll-bars nil)
   (int   :interactor  :min-height 100 :max-height 100 :height 100 :width 600))
  (:layouts
   (default
    (progn
      (setf (slot-value clim:*application-frame* 'scene-pane) scene)
      (clim:vertically () scene int)))))

(defun sketchpad ()
  (let ((frame (clim:make-application-frame 'sketchpad-app)))
    (bt:make-thread
     (lambda ()
       (clim:run-frame-top-level frame)))
    frame))

(defun draw-scene (frame pane)
  (let* ((size (clim:sheet-region pane))
         (width (clim:rectangle-width size))
         (height (clim:rectangle-height size)))
    (clim:with-drawing-options (pane
                                :transformation (clim:make-transformation 1 0 0 -1
                                                                          (/ width 2)
                                                                          (/ height 4)))
      (let ((entities (entities frame)))
        (dolist (entity entities)
          (clim:present entity
                        (clim:presentation-type-of entity)
                        :stream pane))))))

(defun step-frame (frame)
  (let ((entities (entities frame)))
    (mapc #'pre-constraints entities)
    (mapc #'add-constraints entities)
    (mapc #'post-constraints entities)))

(defmethod clim:handle-event ((pane scene-pane) (event clim:timer-event))
  (clim:execute-frame-command clim:*application-frame* '(com-step 1))
  (clim-internals::schedule-event pane
                                  (make-instance 'clim:timer-event
                                                 :token 'redraw-timer
                                                 :sheet pane)
                                  0.02))

