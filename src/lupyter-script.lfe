(defmodule lupyter-script
  (export all))

(defun update-paths ()
  (let ((`#(ok ,dirs) (file:list_dir "deps")))
    (code:add_pathsa (prepend-deps dirs)))
  (code:add_patha "ebin"))

(defun prepend-deps (dirs)
  (lists:map (lambda (x)
               (++ "deps/" x "/ebin"))
             dirs))

(defun main (args)
  (update-paths)
  (lupyter-app:start args)
  ;; Next we'll make an unanswered receive call to keep the script running
  (receive
    ('listen 'true)))

(defun main-nonotp (args)
  (update-paths)
  (lupyter-nonotp:main args))