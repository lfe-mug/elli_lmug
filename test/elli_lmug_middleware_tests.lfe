(defmodule elli_lmug_middleware_tests
  (behaviour ltest-unit)
  (export (elli_lmug_middleware_test_ 0)))

(include-lib "ltest/include/ltest-macros.lfe")
(include-lib "lmug/include/request.lfe")
(include-lib "lmug/include/response.lfe")


(deftestgen elli-lmug-middleware
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
  (code:ensure_loaded 'lmug-mw-content-type)
  (application:start 'crypto)
  (application:start 'public_key)
  (application:start 'ssl)
  (inets:start)
  (let* ((config      `[#(mods [#(elli_lmug [#(lmug-mw-content-type [])])])])
         (`#(ok ,pid) (elli:start_link `[#(callback      elli_middleware)
                                         #(callback_args ,config)
                                         #(port          3002)])))
    (unlink pid)
    (list pid)))

(defun teardown (pids) (lists:map #'elli:stop/1 pids))
