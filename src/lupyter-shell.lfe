(defmodule lupyter-shell
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
  ((`#(test ,message) from state)
    (lfe_io:format "Call: ~p~n" `(,message))
    `#(reply ok ,state))
  ((request from state)
    `#(reply ok ,state)))

(defun handle_cast
  ((`#(test ,message) state)
    (lfe_io:format "Cast: ~p~n" `(,message))
    `#(noreply ,state))
  ((message state)
    `#(noreply ,state)))

;;; Callbacks

(defun start_link (args)
  (lupyter-service:start-link (server-name) (MODULE) args))

(defun start_link ()
  (lupyter-service:start-link (server-name) (MODULE)))

(defun init (args)
  (lupyter-service:init (MODULE) (socket-type) args))

(defun handle_info (info state)
  (lupyter-service:handle-info info state))

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