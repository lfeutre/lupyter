(defmodule lupyter-sup
  (behaviour supervisor)
  (export (start_link 0)
          (start_link 1)
          (init 1)))

(defun server-name () (MODULE))

(defun start_link (args)
  (logjam:debug (MODULE) 'start_link/1
                "Starting lupyter supervisor with args ~p ..."
                `(,args))
  (supervisor:start_link
    `#(local ,(server-name)) (MODULE) args))

(defun start_link ()
  (start_link '()))

(defun init (args)
  (let ((children `(,(make-child 'lupyter-bcast args)
                    ,(make-child 'lupyter-control args)
                    ,(make-child 'lupyter-heart args)
                    ,(make-child 'lupyter-shell args)
                    ,(make-child 'lupyter-stdin args)))
        (restart-strategy #(one_for_one 3 1)))
    `#(ok #(,restart-strategy ,children))))

(defun make-child (name)
  (make-child name '()))

(defun make-child (name args)
  (logjam:debug (MODULE) 'make-child/2
                "Creating child ~p with args ~p ..."
                `(,name ,args))
  `#(,name
     #(,name start_link ,args)
     permanent
     2000
     worker
     (,name)))