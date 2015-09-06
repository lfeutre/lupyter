(defmodule unit-lupyter-msg-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest check-with-list
  (let ((signature (lupyter-hmac:new "mykey" "header" "parent" "metadata" "content")))
    (is (lupyter-msg:check signature "mykey" '("header" "parent" "metadata" "content")))))

(deftest check-with-args
  (let ((signature (lupyter-hmac:new "mykey" "header" "parent" "metadata" "content")))
    (is (lupyter-msg:check signature "mykey" "header" "parent" "metadata" "content"))))

(deftest checker-with-list
  (let ((signature (lupyter-hmac:new "mykey" "header" "parent" "metadata" "content"))
        (checker (lupyter-msg:checker "mykey")))
    (is (funcall checker signature '("header" "parent" "metadata" "content")))))

(deftest check-with-list-no-key
  (let ((signature (lupyter-hmac:new "header" "parent" "metadata" "content")))
    (is (lupyter-msg:check signature '("header" "parent" "metadata" "content")))))

(deftest check-with-args-no-key
  (let ((signature (lupyter-hmac:new "header" "parent" "metadata" "content")))
    (is (lupyter-msg:check signature "header" "parent" "metadata" "content"))))

(deftest checker-with-list-no-key
  (let ((signature (lupyter-hmac:new "header" "parent" "metadata" "content"))
        (checker (lupyter-msg:checker)))
    (is (funcall checker signature '("header" "parent" "metadata" "content")))))
