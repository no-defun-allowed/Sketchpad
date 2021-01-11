(asdf:defsystem :sketchpad
  :depends-on (:classowary :alexandria :clim)
  :serial t
  :components ((:file "package")
               (:module "Things"
                :components ((:file "protocol")
                             (:file "coordinate")
                             (:file "point")
                             (:file "weight")
                             (:file "spring")))
               (:module "CLIM"
                :components ((:file "sketchpad")
                             (:file "draw")
                             (:file "commands")))))
