(defmodule lupyter-util
  (export all))

(include-lib "clj/include/compose.lfe")

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