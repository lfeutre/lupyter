(defmodule lupyter-shell
  (behaviour gen_server)
  (export (test-call 1)
          (test-cast 1))
  (export (start_link 0)
          (init 1)
          (handle_call 3)
          (handle_cast 2)
          (handle_info 2)
          (terminate 2)
          (code_change 3)))

(include-lib "lupyter/include/lupyter.lfe")

;;; Callbacks

(defun server-name () (MODULE))

(defun start_link ()
  (gen_server:start_link
     `#(local ,(server-name)) (MODULE) '() '()))

(defun init (args)
  `#(ok ,(make-state)))

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

(defun handle_info (info state)
  `#(noreply ,state))

(defun terminate (reason state)
  'ok)

(defun code_change (old-version state extra)
  `#(ok ,state))

;;; API

(defun test-call (message)
  (gen_server:call
     (server-name) `#(test ,message)))

(defun test-cast (message)
  (gen_server:cast
     (server-name) `#(test ,message)))