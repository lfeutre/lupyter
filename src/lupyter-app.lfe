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
  (logjam:debug (MODULE) 'start/2 "~p" `(,args))
  (logjam:debug (MODULE) 'start/2 "~p" `(,(init:get_arguments)))
  (let* ((`#(ok ,context) (erlzmq:context))
         (state (set-state (lupyter-util:args->rec args) context context)))
    (logjam:info (MODULE) 'start/2  "Starting lupyter application ...")
    (logjam:debug (MODULE) 'start/2 "Args ~p ..." `(,args))
    (let ((result (lupyter-sup:start_link state)))
      (case result
        (`#(ok ,pid)
         result)
        (x x)))))

(defun stop (state)
  (logjam:info (MODULE) 'stop/1  "Stopping lupyter application ...")
  'ok)
