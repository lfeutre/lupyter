(defmodule lupyter-app
  (behaviour application)
  (export (start 0)
          (start 1)
          (start 2)
          (stop 1)))

(include-lib "lupyter/include/lupyter.lfe")

(defun start ()
  (start 'normal '()))

(defun start (args)
  (start 'normal args))

(defun start (type args)
  (logjam:start)
  (logjam:debug (MODULE) 'start/2 "Creating 0MQ context ...")
  (let* ((`#(ok ,context) (erlzmq:context))
         (state (set-state (args->rec args) context context)))
    (logjam:debug (MODULE) 'start/2
                  "Starting lupyter application with args ~p ..."
                  `(,args))
    (let ((result (lupyter-sup:start_link state)))
      (case result
        (`#(ok ,pid)
         result)
        (x x)))))

(defun stop (state)
  'ok)

(defun args->rec (args)
  (case (lupyter-util:get-arg-value "--conn-info" args)
    (`#(ok ,filename)
     (make-state
      cfg (ljson:read filename)))
    (error error)))