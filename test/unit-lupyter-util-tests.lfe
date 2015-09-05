(defmodule unit-lupyter-util-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest hmac-with-payload
  (is-equal
   "9e16cc488504e966d16c7f443ee97c0e46ec1e8aad7164c1032e466fb6ea30ac"
   (lupyter-util:hmac "mykey" "headerparentmetadatacontent")))

(deftest hmac-with-args
  (is-equal
   "9e16cc488504e966d16c7f443ee97c0e46ec1e8aad7164c1032e466fb6ea30ac"
   (lupyter-util:hmac "mykey" "header" "parent" "metadata" "content")))

(deftest int->hex
  (is-equal "01" (lupyter-util:int->hex 1))
  (is-equal "0A" (lupyter-util:int->hex 10))
  (is-equal "10" (lupyter-util:int->hex 16)))