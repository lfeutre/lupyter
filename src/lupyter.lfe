(defmodule lupyter
  (export (start 0)))

(defun start ()
  (application:ensure_started 'lupyter))