(defmodule lupyter-sup
  (behaviour supervisor)
  (export (start_link 0))
  (export (init 1)))

(defun server-name ()
  'lupyter-sup)

(defun start_link ()
  (supervisor:start_link
    `#(local ,(server-name)) (MODULE) '()))

(defun init (args)
  (let ((children `(,(make-child 'lupyter-bcast)
                    ,(make-child 'lupyter-control)
                    ,(make-child 'lupyter-heart)
                    ,(make-child 'lupyter-shell)
                    ,(make-child 'lupyter-stdin)))
        (restart-strategy #(one_for_one 3 1)))
    `#(ok #(,restart-strategy ,children))))

(defun make-child (name)
  `#(,name
     #(,name start_link ())
     permanent
     2000
     worker
     (,name)))