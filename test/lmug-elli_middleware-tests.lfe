(defmodule lmug-elli_middleware-tests
  (behaviour ltest-unit)
  (export (lmug_elli_middleware_test_ 0)))

(include-lib "clj/include/compose.lfe")
(include-lib "ltest/include/ltest-macros.lfe")
(include-lib "lmug/include/request.lfe")
(include-lib "lmug/include/response.lfe")


(deftestgen lmug-elli-middleware
  "Tests based on [`elli_middleware_tests`][1] and
  [`lmug-mw-content-type-tests`][2].

  [1]: https://github.com/knutin/elli/blob/master/test/elli_middleware_tests.erl
  [2]: https://github.com/lfe-mug/lmug/blob/master/test/lmug-mw-content-type-tests.lfe"
  (tuple 'setup (defsetup setup) (defteardown teardown)
         (list (content_types))))


;;;===================================================================
;;; Tests
;;;===================================================================

(defun content_types ()
  (lc ((<- `#(,expected ,url)
           '[#("application/json"         "http://localhost:3002/file.json")
             #("application/json"         "http://localhost:3002/.json")
             #("application/octet-stream" "http://localhost:3002/file.")
             #("application/octet-stream" "http://localhost:3002/file")
             #("text/html"                "http://localhost:3002/index.html")]))
    (tuple (++ url " => " expected)
           (_test (let ((`#(ok ,response) (httpc:request url)))
                    (is-equal 200 (status response))
                    (is-equal expected (content-type response))
                    ;; FIXME: #"" once lmug uses binaries
                    (is-equal "" (body response)))))))


;;;===================================================================
;;; Helper functions
;;;===================================================================

(defun status ([`#(#(,_ ,status ,_) ,_ ,_)] status))

(defun body ([`#(,_ ,_ ,body)] body))

(defun headers ([`#(,_ ,headers ,_)] (lists:sort headers)))

(defun content-type (response)
  (proplists:get_value "content-type" (headers response)))

(defun setup ()
  (application:ensure_all_started 'inets)
  (logjam:start)
  (logjam:set-level 'info)
  (-> (lmug:response)
      (lmug-mw-identity:wrap)
      (lmug-mw-content-type:wrap)
      (lmug-mw-identity:wrap)
      (lmug-elli:run '[#(port 3002)])))

(defun teardown (pids) (lists:map #'elli:stop/1 pids))
