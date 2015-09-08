(defmodule lupyter-control
  (behaviour gen_server)
  (export (test-call 1)
          (test-cast 1))
  (export (start_link 0)
          (start_link 1)
          (init 1)
          (handle_call 3)
          (handle_cast 2)
          (handle_info 2)
          (terminate 2)
          (code_change 3)))

(include-lib "lupyter/include/lupyter.lfe")

;;; Config

(defun server-name () (MODULE))
(defun socket-type () 'router)

;;; API dispatch callbacks

(defun handle_call
  ((`#(test ,message) from (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_call/3 "Call: ~p~n" `(,message))
   `#(reply ok ,state))
  ((message from state)
   (logjam:warn (MODULE) 'handle_call/3 "Unmatched message: ~p" `(,message))
   `#(reply ok ,state)))

(defun handle_cast
  ((`#(test ,message) (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_cast/2 "Cast: ~p~n" `(,message))
   `#(noreply ,state))
  ((message state)
   (logjam:warn (MODULE) 'handle_case/2 "Unmatched message: ~p" `(,message))
   `#(noreply ,state)))

(defun handle_info
  (((= `#(zmq ,_ ,_ ,_) info) state)
   (logjam:debug (MODULE) 'handle_info/2 "XXX: Implement this ..."))
  ((info state)
   (lupyter-service:handle-info (MODULE) info state)))

;;; Callbacks

(defun start_link (args)
  (lupyter-service:start-link (server-name) (MODULE) args))

(defun start_link ()
  (lupyter-service:start-link (server-name) (MODULE)))

(defun init (args)
  (lupyter-service:init (MODULE) (socket-type) args))

(defun terminate (reason state)
  (lupyter-service:terminate reason state))

(defun code_change (old-version state extra)
  (lupyter-service:code-change old-version state extra))

;;; API

(defun test-call (message)
  (gen_server:call
     (server-name) `#(test ,message)))

(defun test-cast (message)
  (gen_server:cast
     (server-name) `#(test ,message)))
