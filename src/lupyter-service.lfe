;;;; This module provides some basic gen_server functions that are the same
;;;; across multiple services in the lupyter app.

(defmodule lupyter-service
  (export all))

(include-lib "lupyter/include/lupyter.lfe")

(defun start-link (server-name mod args)
  (logjam:info mod 'start_link/1 "Starting ~p gen_server ..." `(,mod))
  (logjam:debug mod 'start_link/1 "Args: ~p" `(,args))
  (let ((genserver-opts '()))
    (gen_server:start_link
     `#(local ,server-name) mod args genserver-opts)))

(defun start-link (server-name mod)
  (start-link server-name mod '()))

(defun init
  ((mod socket-type port-name (= (match-state context ctx config cfg) state))
   (let* ((`#(ok ,skt) (erlzmq:socket ctx socket-type))
          (transport (ljson:get '(#"transport") cfg))
          (ip (ljson:get '(#"ip") cfg))
          (port (integer_to_binary (ljson:get `(,port-name) cfg)))
          (url (binary (transport binary) "://" (ip binary) ":" (port binary))))
     (logjam:debug mod 'init/1
                   "Initializing ~p with socket ~p ..."
                   `(,mod ,skt))
     (logjam:debug mod 'init/1 "Binding to ~p ..." `(,url))
     (case (erlzmq:bind skt url)
       ('ok 'ok))
     `#(ok ,(set-state-socket state skt)))))

(defun handle-info (mod info state)
  (logjam:warn mod 'handle_info/2 "Got unexpected message: ~p" `(,info))
  `#(noreply ,state))

(defun terminate
  ((mod reason (= (match-state socket skt) state))
   (logjam:warn mod 'terminate/2 "Terminating ~p ..." `(,mod))
   (erlzmq:close skt)))

(defun code-change (old-version state extra)
  `#(ok ,state))