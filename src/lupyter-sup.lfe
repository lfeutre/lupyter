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

(defun init (state)
  (let ((children `(,(make-child 'lupyter-bcast state)
                    ,(make-child 'lupyter-control state)
                    ,(make-child 'lupyter-heart state)
                    ,(make-child 'lupyter-shell state)
                    ,(make-child 'lupyter-stdin state)))
        (restart-strategy #(one_for_one 3 1)))
    `#(ok #(,restart-strategy ,children))))

(defun make-child (name)
  (make-child name '()))

(defun make-child (name state)
  (logjam:debug (MODULE) 'make-child/2 "Creating child ~p ..." `(,name))
  `#(,name
     #(,name start_link (,state))
     permanent
     2000
     worker
     (,name)))