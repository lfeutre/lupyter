(defmodule lupyter-util
  (export all))

(include-lib "clj/include/compose.lfe")

(defun get-version ()
  (lutil:get-app-version 'lupyter))

(defun get-versions ()
  (++ (lutil:get-versions)
      `(#(ljson ,(lutil:get-app-version 'ljson))
        #(erlzmq2 ,(lutil:get-app-version 'erlzmq))
        #(lupyter ,(get-version)))))

(defun hmac (key header parent metadata content)
  (hmac key (++ header parent metadata content)))

(defun hmac (key payload)
  (->> payload
       (crypto:hmac 'sha256 key)
       (bin->hex)
       (lists:flatten)
       (string:to_lower)))

(defun bin->hex (bin)
  (bin->hex bin ""))

(defun bin->hex
  ((#b() data)
   data)
  (((binary head (tail binary)) data)
   (bin->hex tail (++ data (int->hex head)))))

(defun int->hex (int)
  (-> int
      (integer_to_list 16)
      (string:right 2 #\0)))
