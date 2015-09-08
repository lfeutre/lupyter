;;;; This module provides some basic gen_server functions that are the same
;;;; across multiple services in the lupyter app.

(defmodule lupyter-service
  (export all))

(include-lib "lupyter/include/lupyter.lfe")

(defun start-link (server-name mod args)
  (logjam:debug mod 'start_link/1
                "Starting ~p gen_server with args ~p"
                `(,mod ,args))
  (let ((genserver-opts '()))
    (gen_server:start_link
     `#(local ,server-name) mod args genserver-opts)))

(defun start-link (server-name mod)
  (start-link server-name mod '()))

(defun init
  ((mod socket-type (= (match-state context ctx) state))
   (let ((`#(ok ,skt) (erlzmq:socket ctx socket-type)))
     (logjam:debug mod 'init/1
                   "Initializing ~p with socket ~p"
                   `(,mod ,skt))
     `#(ok ,(set-state-socket state skt)))))

(defun handle-info (info state)
  `#(noreply ,state))

(defun terminate (reason state)
  'ok)

(defun code-change (old-version state extra)
  `#(ok ,state))