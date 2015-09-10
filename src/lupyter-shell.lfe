;;;; This module does not provide an API, but rather receives messages and
;;;; dispatches responses back to the remote callers.

(defmodule lupyter-shell
  (behaviour gen_server)
  (export all))

(include-lib "lupyter/include/lupyter.lfe")

;;; Config

(defun server-name () (MODULE))
(defun socket-type () 'router)
(defun port-name () #"shell_port")

;;; Callbacks

(defun handle_info
  (((= `#(zmq ,_ "kernel_info_request" ,flags) info)
    (= (match-state socket skt) state))
   (logjam:info (MODULE) 'handle_info/2 "Got kernel_info_request ...")
   (logjam:info "info: ~p" `(,info))
   `#(noreply ,state))
  (((= `#(zmq ,_ "execute_request" ,flags) info)
    (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_info/2 "Got execute_request ...")
   `#(noreply ,state))
  (((= `#(zmq ,_ "complete_request" ,flags) info)
    (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_info/2 "Got complete_request ...")
   `#(noreply ,state))
  (((= `#(zmq ,_ "is_complete_request" ,flags) info)
    (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_info/2 "Got is_complete_request ...")
   `#(noreply ,state))
  (((= `#(zmq ,_ "history_request" ,flags) info)
    (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_info/2 "Got history_request ...")
   `#(noreply ,state))
  (((= `#(zmq ,_ "kernel_info_request" ,flags) info)
    (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_info/2 "Got kernel_info_request ...")
   `#(noreply ,state))
  (((= `#(zmq ,_ "kernel_info_request" ,flags) info)
    (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_info/2 "Got kernel_info_request ...")
   `#(noreply ,state))
  ((info state)
   (lupyter-service:handle-info (MODULE) info state)))

;;; Callbacks

(defun start_link (args)
  (lupyter-service:start-link (server-name) (MODULE) args))

(defun start_link ()
  (lupyter-service:start-link (server-name) (MODULE)))

(defun init (args)
  (lupyter-service:init (MODULE) (socket-type) (port-name) args))

(defun terminate (reason state)
  (lupyter-service:terminate (MODULE) reason state))

(defun code_change (old-version state extra)
  (lupyter-service:code-change old-version state extra))

;;; Receive functions

(defun recv-kernel-info-req ()
  )

(defun recv-execute-req ()
  )

(defun recv-complete-req ()
  )

(defun recv-is-complete-req ()
  )

(defun recv-history-req ()
  )

;;; Reply functions

(defun send-kernel-info-reply ()
  )

(defun send-execute-reply ()
  )

(defun send-complete-reply ()
  )

(defun send-is-complete-reply ()
  )

(defun history-reply ()
  )