(defmodule lupyter-app
  (behaviour application)
  (export (start 0) (start 2)
          (stop 1)))

(defun start ()
  (start 'normal '()))

(defun start (type args)
  (let ((result (: lupyter-sup start_link)))
    (case result
      ((tuple 'ok pid)
        result)
      (_
        (tuple 'error result)))))

(defun stop (state)
  'ok)
