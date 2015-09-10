(defmodule lupyter-util
  (export all))

(include-lib "clj/include/compose.lfe")
(include-lib "lupyter/include/lupyter.lfe")

(defun get-version ()
  (lutil:get-app-version 'lupyter))

(defun get-versions ()
  (++ (lutil:get-versions)
      `(#(ljson ,(lutil:get-app-version 'ljson))
        #(erlzmq2 ,(lutil:get-app-version 'erlzmq))
        #(lupyter ,(get-version)))))

(defun kernel-version () #"5.0")

(defun lfe-version ()
  (->> (get-versions)
       (proplists:get_value 'lfe)
       (list_to_binary)))

(defun get-kernel-info ()
  `(#(protocol_version ,(kernel-version))
    #(language #"lfe")
    #(language_version ,(lfe-version))))

(defun now ()
  (format-time (os:timestamp)))

(defun format-time (timestamp)
  (iso8601:format timestamp))

(defun args->rec (args)
  (case (get-arg-value "--conn-info" args)
    (`#(ok ,filename)
     (make-state
       config (ljson:read filename)))
    (error error)))

(defun get-arg-value
  ((key '())
   (get-init-arg-value key))
  ((key args)
   (case (get-script-arg-value key args)
     (`#(error ,_)
      (get-init-arg-value key))
     (val val))))

(defun get-script-arg-value (key args)
   (case (lists:keyfind key 1 args)
     (`#(,key ,val)
      `#(ok ,val))
     (_ #(error key-not-found))))

(defun get-init-arg-value (key)
  (let ((key (list_to_atom (lists:nthtail 2 key))))
    (case (proplists:get_value key (init:get_arguments))
      (`(,file) `#(ok ,(list_to_binary file)))
      (_ #(error key-not-found)))))

(defun args->plist (args)
  (lists:map #'arg->tuple/1 args))

(defun arg->tuple (arg)
  (case (string:tokens arg "=")
    (`(,key ,val)
     `#(,key ,val))))

(defun make-zmq-url (port-name cfg)
  (let ((transport (ljson:get '(#"transport") cfg))
        (ip (ljson:get '(#"ip") cfg))
        (port (integer_to_binary (ljson:get `(,port-name) cfg))))
    (binary (transport binary) "://" (ip binary) ":" (port binary))))
