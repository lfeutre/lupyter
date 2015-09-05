(defmodule unit-lupyter-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest code-change
  (is-equal 1 1))