(defmodule lupyter-bcast
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
(defun socket-type () 'pub)
(defun port-name () #"iopub_port")

;;; API dispatch callbacks

(defun handle_call
  ((`#(test ,message) from (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_call/3 "Call test: ~p~n" `(,message))
   `#(reply ok ,state))
  ((message from state)
   (logjam:warn (MODULE) 'handle_call/3 "Unmatched message: ~p" `(,message))
   `#(reply ok ,state)))

(defun handle_cast
  ;; Test functions
  ((`#(test ,message) (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_cast/2 "Cast test: ~p~n" `(,message))
   `#(noreply ,state))
  ((`#(send-status ,message ,status) (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_cast/2 "Sending status ...")
   (lupyter-msg:send skt message "status" `(#(execution_state ,status)))
   `#(noreply ,state))
  ;; Execution input
  ((`#(send-execute-input ,message ,execution-count)
    (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_cast/2 "Sending execute input ...")
   (lupyter-msg:send skt message "execute_input"
                     `(#(execution_count ,execution-count)
                       #(code #"XXX - add me")))
   `#(noreply ,state))
  ;; Execution result
  ((`#(send-execute-result ,message #(,text ,execution-count))
    (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_cast/2 "Sending execute result ...")
   (lupyter-msg:send skt message "execute_result"
                     `(#(execution_count ,execution-count)
                       #(metadata ())
                       #(data (#(text/plain ,text)))))
   `#(noreply ,state))
  ;; Stream
  ((`#(send-stream ,message ,text) (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_cast/2 "Sending stream ...")
   (lupyter-msg:send skt message "stream" `(#(name "stdout")
                                            #(text ,text)))
   `#(noreply ,state))
  ;; Error
  ((`#(send-error ,message ,execution-count ,exception-name ,traceback)
    (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_cast/2 "Sending error ...")
   (lupyter-msg:send skt message "error" `(#(execution_count ,execution-count)
                                           #(ename ,exception-name)
                                           #(evalue "1")
                                           #(traceback ,traceback)))
   `#(noreply ,state))
  ;; No match
  ((message state)
   (logjam:warn (MODULE) 'handle_cast/2 "Unmatched message: ~p" `(,message))
   `#(noreply ,state)))

(defun handle_info
  (((= `#(zmq ,_ ,data ()) info) (= (match-state socket skt) state))
   (logjam:debug (MODULE) 'handle_info/2 "Sending heartbeat data ...")
   (erlzmq:send skt data)
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

;;; API

(defun test-call (message)
  (gen_server:call
    (server-name) `#(test ,message)))

(defun test-cast (message)
  (gen_server:cast
    (server-name) `#(test ,message)))

(defun send-status (message status)
  (gen_server:cast
    (server-name) `#(send-status ,message ,status)))

(defun send-execute-input (message execution-count)
  (gen_server:cast
    (server-name) `#(send-execute-input ,message ,execution-count)))

(defun send-execute-result (message text)
  (gen_server:cast
    (server-name) `#(send-execute-result ,message ,text)))

(defun send-stream (message text)
  (gen_server:cast
    (server-name) `#(send-stream ,message ,text)))

(defun send-error (message execution-count exception-name traceback)
  (gen_server:cast
    (server-name) `#(send-error ,message
                                ,execution-count
                                ,exception-name
                                ,traceback)))

