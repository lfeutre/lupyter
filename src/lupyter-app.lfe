(defmodule lupyter-app
  (behaviour application)
  (export (start 0)
          (start 2)
          (stop 1)))

(defun start ()
  (start 'normal '()))

(defun start
  ((type '())
   (logjam:debug (MODULE) 'start/2 "Creating 0MQ context ...")
   (let ((`#(ok ,context) (erlzmq:context)))
     (start type `(#(context ,context)))))
  ((type args)
   (logjam:start)
   (logjam:debug (MODULE) 'start/2
                 "Starting lupyter application with args ~p ..."
                 `(,args))
   (let ((result (lupyter-sup:start_link args)))
     (case result
       (`#(ok ,pid)
        result)
       (x x)))))

(defun stop (state)
  'ok)
