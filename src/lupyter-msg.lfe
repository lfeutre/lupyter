(defmodule lupyter-msg
  (export all))

(include-lib "lupyter/include/lupyter.lfe")
(include-lib "clj/include/seq.lfe")

(defun check (signature data)
  (check signature "" data))

(defun check (signature key data)
  (apply #'check/6 (++ `(,signature ,key) data)))

(defun check (signature header parent metadata content)
  (check signature "" header parent metadata content))

(defun check (signature key header parent metadata content)
  (=:= signature
     (lupyter-hmac:new key header parent metadata content)))

(defun checker ()
  (lambda (sig data)
    (check sig data)))

(defun checker (key)
  (lambda (sig data)
    (check sig key data)))

(defun decode
  (('(uuid "<IDS|MSG>" baddad42 header parent-header metadata content blob))
   'noop)
  ((msg)
   (log:err (MODULE) 'parse/1 "Bad message format: ~p" `(,msg))
   #(error 'bad-message-format)))

(defun encode (message)
  'noop)

(defun encode (header parent metadata content)
  (let ((json-header (ljson:encode (list_to_binary header)))
        (json-parent (ljson:encode (list_to_binary parent)))
        (json-metadata (ljson:encode (list_to_binary metadata)))
        (json-content (ljson:encode (list_to_binary content))))
    (list (lutil:uuid4)
          (binary "<IDS|MSG>")
          (lupyter-hmac:new json-header json-parent json-metadata json-content)
          json-header
          json-parent
          json-metadata
          json-content)))

(defun new-header (msg-type session-id)
  `(#(date ,(lupyter-util:now))
    #(msg_id ,(lutil:uuid4))
    #(username #"kernel")
    #(session ,session-id)
    #(msg_type ,msg-type)))

(defun kernel-info-header (msg)
  (let ((hdr (ljson:encode `(#(msg_id ,(lutil:uuid4))
                             #(username ,(get-in msg '(header username)))
                             #(session ,(get-in msg '(header session)))
                             #(msg_type #"kernel_info_reply")
                             #(version ,(lupyter-util:kernel-version))))))
    (logjam:debug (MODULE)
                  'kernel-info-header/1
                  "~nMessage: ~p~nHeader: ~p"
                  `(,msg ,hdr))
    hdr))

(defun comm-close-header (_msg)
  (let ((hdr (ljson:encode `(#(msg_id ,(lutil:uuid4))
                             #(data #"")
                             #(msg_type #"comm_close")))))
    (logjam:debug (MODULE)
                  'comm-close-header/1
                  "~nMessage: ~p~nHeader: ~p"
                  `(,_msg ,hdr))
    hdr))

(defun send (skt message message-type content)
  (send skt (encode (++ message
                        `(#(header #(#"XXX - add me")
                                   #(msg_type ,message-type))
                          #(parent_header #(#"XXX - add me"))
                          #(content ,content))))))

(defun send
  ((skt `(,message))
   (case (erlzmq:send skt message '())
     ('ok 'ok)))
  ((skt `(,message . ,messages))
   (case (erlzmq:send skt message '(sndmore))
     ('ok 'ok))
   (send skt messages)))