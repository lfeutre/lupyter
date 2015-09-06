(defmodule unit-lupyter-hmac-tests
  (behaviour ltest-unit)
  (export all))

(include-lib "ltest/include/ltest-macros.lfe")
(include-lib "clj/include/compose.lfe")

(deftest new-str-with-payload
  (is-equal
   "9e16cc488504e966d16c7f443ee97c0e46ec1e8aad7164c1032e466fb6ea30ac"
   (lupyter-hmac:new-str "mykey" "headerparentmetadatacontent")))

(deftest new-str-with-payload-no-key
  (is-equal
   "56f7d3542a4d4ea5389947fc742ac789347467e49d26bd9c1df5c42b51656023"
   (lupyter-hmac:new-str "headerparentmetadatacontent")))

(deftest new-str-with-args
  (is-equal
   "9e16cc488504e966d16c7f443ee97c0e46ec1e8aad7164c1032e466fb6ea30ac"
   (lupyter-hmac:new-str "mykey" "header" "parent" "metadata" "content")))

(deftest new-str-with-args-no-key
  (is-equal
   "56f7d3542a4d4ea5389947fc742ac789347467e49d26bd9c1df5c42b51656023"
   (lupyter-hmac:new-str "header" "parent" "metadata" "content")))

(deftest new-with-args
  (is-equal
   #"9e16cc488504e966d16c7f443ee97c0e46ec1e8aad7164c1032e466fb6ea30ac"
   (lupyter-hmac:new "mykey" "header" "parent" "metadata" "content")))

(deftest new-with-args-no-key
  (is-equal
   #"56f7d3542a4d4ea5389947fc742ac789347467e49d26bd9c1df5c42b51656023"
   (lupyter-hmac:new "header" "parent" "metadata" "content")))

(deftest new-as-list
  (is-equal
   #"9e16cc488504e966d16c7f443ee97c0e46ec1e8aad7164c1032e466fb6ea30ac"
   (lupyter-hmac:new "mykey" '("header" "parent" "metadata" "content"))))

(deftest new-as-list-no-key
  (is-equal
   #"56f7d3542a4d4ea5389947fc742ac789347467e49d26bd9c1df5c42b51656023"
   (lupyter-hmac:new '("header" "parent" "metadata" "content"))))

(deftest update
  (is-equal "CE3837F76A54A635191B1704AC7672264FC17C3397FF52E7DACFC1EF3603A493"
            (->> ""
                 (crypto:hmac_init (lcfg:get-in '(crypto hmac-type)))
                 (lupyter-hmac:update "alice")
                 (crypto:hmac_final)
                 (lupyter-hmac:bin->hex)))
  (is-equal "CE3837F76A54A635191B1704AC7672264FC17C3397FF52E7DACFC1EF3603A493"
            (->> ""
                 (crypto:hmac_init (lcfg:get-in '(crypto hmac-type)))
                 (lupyter-hmac:update #"alice")
                 (crypto:hmac_final)
                 (lupyter-hmac:bin->hex))))

(deftest update-all
  (is-equal "B6F593544F05CFE3F7FFABE8A54FCBFB54AF7ED3E8EB7D4A68739A5539D1F636"
            (->> ""
                 (crypto:hmac_init (lcfg:get-in '(crypto hmac-type)))
                 (lupyter-hmac:update-all '("alice" "bob" "carol"))
                 (crypto:hmac_final)
                 (lupyter-hmac:bin->hex)))
  (is-equal "B6F593544F05CFE3F7FFABE8A54FCBFB54AF7ED3E8EB7D4A68739A5539D1F636"
            (->> ""
                 (crypto:hmac_init (lcfg:get-in '(crypto hmac-type)))
                 (lupyter-hmac:update-all '(#"alice" #"bob" #"carol"))
                 (crypto:hmac_final)
                 (lupyter-hmac:bin->hex))))

(deftest int->hex
  (is-equal "01" (lupyter-hmac:int->hex 1))
  (is-equal "0A" (lupyter-hmac:int->hex 10))
  (is-equal "10" (lupyter-hmac:int->hex 16)))