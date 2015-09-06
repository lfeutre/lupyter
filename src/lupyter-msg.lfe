(defmodule lupyter-msg
  (export all))

(include-lib "lupyter/include/lupyter.lfe")

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

(defun send ()
  'noop)