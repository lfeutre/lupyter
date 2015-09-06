(defmodule unit-lupyter-util-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")

(deftest get-kernel-info
  (is-equal `(#(protocol_version #"5.0")
              #(language #"lfe")
              #(language_version #"0.10.0-dev"))
            (lupyter-util:get-kernel-info)))