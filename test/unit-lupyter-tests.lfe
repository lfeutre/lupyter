(defmodule unit-lupyter-tests
  (behaviour ltest-unit)
  (export all)
  (import
    (from ltest
      (check-failed-assert 2)
      (check-wrong-assert-exception 2))))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest code-change
  (is-equal
    ;; XXX This unit test fails by default -- fix it!
    #(ok "data")
    (: lupyter-server code_change
       '"old version"
       '"state"
       '"extra")))
