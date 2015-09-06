(defmodule lupyter-hmac
  (export all))

(include-lib "clj/include/compose.lfe")

(defun new-str (header parent metadata content)
  (new-str "" (++ header parent metadata content)))

(defun new-str (key header parent metadata content)
  (new-str key (++ header parent metadata content)))

(defun new-str (payload)
  (new-str "" payload))

(defun new-str (key payload)
  (->> payload
       (crypto:hmac (lcfg:get-in '(crypto hmac-type)) key)
       (bin->hex)
       (lists:flatten)
       (string:to_lower)))

(defun new (header parent metadata content)
  (new "" `(,header ,parent ,metadata ,content)))

(defun new (key header parent metadata content)
  (new key `(,header ,parent ,metadata ,content)))

(defun new (items)
  (new "" items))

(defun new (key items)
  (->> key
       (crypto:hmac_init (lcfg:get-in '(crypto hmac-type)))
       (update-all items)
       (crypto:hmac_final)
       (bin->hex)
       (lists:flatten)
       (string:to_lower)
       (list_to_binary)))

(defun update (data context)
  (crypto:hmac_update context data))

(defun update-all (items context)
  (lists:foldl #'update/2 context items))

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
