(defmodule lupyter-util
  (export all))

(defun get-version ()
  (lutil:get-app-version 'lupyter))

(defun get-versions ()
  (++ (lutil:get-versions)
      `(#(ljson ,(lutil:get-app-version 'ljson))
        #(erlzmq2 ,(lutil:get-app-version 'erlzmq))
        #(lupyter ,(get-version)))))
