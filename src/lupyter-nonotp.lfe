(defmodule lupyter-nonotp
  (export all))

(include-lib "lupyter/include/lupyter.lfe")

;;; Entry point and configuration

(defun main ()
  (main '()))

(defun main (args)
  (logjam:start)
  (logjam:debug (MODULE) 'main/1 "Creating 0MQ context ...")
  (logjam:debug (MODULE) 'main/1 "~p" `(,args))
  (logjam:debug (MODULE) 'main/1 "~p" `(,(init:get_arguments)))
  (let* ((`#(ok ,ctx) (erlzmq:context))
         (state (set-state (lupyter-util:args->rec args) context ctx)))
    (logjam:info (MODULE) 'main/1  "Setting up lupyter ...")
    (logjam:debug (MODULE) 'main/1 "Args ~p ..." `(,args))
    (setup state)))

(defun setup
  (((= (match-state config cfg context ctx) state))
   (logjam:debug (MODULE) 'setup/2 "Process: ~p" `(,(self)))
   (let* ((shell-skt (init-shell ctx cfg))
          (iopub-skt (init-iopub ctx cfg))
          (hb-skt (init-heartbeat ctx cfg))
          (key (ljson:get '(#"key") cfg)))
     (heartbeat-loop hb-skt)
     (shell-loop shell-skt
                 iopub-skt
                 (set-state-context state ctx)))))

;;; Set up servers

(defun init-shell (ctx cfg)
  (logjam:info (MODULE) 'init-shell/2 "Initializing shell server ...")
  (logjam:debug (MODULE) 'init-shell/2 "URL: ~p" `(,(lupyter-util:make-zmq-url #"shell_port" cfg)))
  (logjam:debug (MODULE) 'init-shell/2 "Got context: ~p" `(,ctx))
  (case (erlzmq:socket ctx 'router)
    (`#(ok ,skt)
      (logjam:debug (MODULE) 'init-shell/2 "Got socket: ~p" `(,skt))
      (erlzmq:bind skt (lupyter-util:make-zmq-url #"shell_port" cfg))
      skt)
    (err
      (logjam:error (MODULE) 'init-shell/2 "~p" `(,err))
      err)))

(defun init-iopub (ctx cfg)
  (logjam:info (MODULE) 'init-iopub/2 "Initializing iopub server ...")
  (case (erlzmq:socket ctx 'pub)
    (`#(ok ,skt)
      (erlzmq:bind skt (lupyter-util:make-zmq-url #"iopub_port" cfg))
      skt)
    (err
      err)))

(defun init-heartbeat (ctx cfg)
  (logjam:info (MODULE) 'init-heartbeat/2 "Initializing heartbeat server ...")
  (case (erlzmq:socket ctx 'rep)
    (`#(ok ,skt)
      (erlzmq:bind skt (lupyter-util:make-zmq-url #"hb_port" cfg))
      skt)
    (err
     err)))

(defun heartbeat-loop (hb-skt)
  (logjam:debug (MODULE) 'heartbeat-loop/2 "Spawning heartbeat listener ...")
  (spawn (lambda ()
           (case (erlzmq:recv hb-skt)
             (`#(ok ,msg)
              (logjam:debug (MODULE) 'run-heartbeat/2
                            "Got heartbeat message: ~p" `(,msg))
              (erlzmq:send hb-skt msg)
              (heartbeat-loop hb-skt))
             (err err)))))

(defun shell-loop (shell-skt iopub-skt state)
  (receive
    (msg
     (logjam:info (MODULE) 'shell-loop/3 "Got message: ~p" `(,msg))
     (shell-loop shell-skt iopub-skt state))))