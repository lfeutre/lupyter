(defmodule lupyter-util
  (export all))

(defun get-version ()
  (lutil:get-app-version 'lupyter))

(defun get-versions ()
  (++ (lutil:get-versions)
      `(#(lupyter ,(get-version)))))
