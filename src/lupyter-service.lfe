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
   (let ((`#(ok ,skt) (get-socket ctx socket-type (self)))
         (url (lupyter-util:make-zmq-url port-name cfg)))
     (logjam:info mod 'init/1
                   "Initializing ~p with socket ~p ..."
                   `(,mod ,skt))
     (logjam:info mod 'init/1 "Binding to ~p ..." `(,url))
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

(defun get-socket
  ;; ((ctx type pid) (when (andalso (=/= type 'pub) (=/= type 'push) (=/= type 'xpub)))
  ;;  (erlzmq:socket ctx `(,type #(active_pid ,pid))))
  ((ctx type _pid)
   (erlzmq:socket ctx type)))