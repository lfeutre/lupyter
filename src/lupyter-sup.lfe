(defmodule lupyter-sup
  (behaviour supervisor)
  ;; API
  (export (start_link 0))
  ;; Supervisor callbacks
  (export (init 1)))

(defun server-name ()
  'lupyter-sup)

(defun start_link ()
  (: supervisor start_link
    (tuple 'local (server-name)) (MODULE) '()))

(defun init (args)
  (let* ((server (tuple
                   'lupyter-server
                   (tuple 'lupyter-server 'start_link '())
                   'permanent
                   2000
                   'worker
                   (list 'lupyter-server)
                   ))
         (children (list server))
         (restart-strategy (tuple 'one_for_one 3 1)))
    (tuple 'ok (tuple restart-strategy children))))
