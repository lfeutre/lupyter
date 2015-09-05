(defmodule lupyter-app
  (behaviour application)
  (export (start 0) (start 2)
          (stop 1)))

(defun start ()
  (start 'normal '()))

(defun start (type args)
  (logjam:start)
  (let ((result (lupyter-sup:start_link)))
    (case result
      (`#(ok ,pid)
        result)
      (_
        `#(error ,result)))))

(defun stop (state)
  'ok)
