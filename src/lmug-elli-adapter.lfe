(defmodule lmug-elli-adapter
  (doc "TODO: write docstring")
  (behaviour elli_handler)
  (exports (run 2)
           (handle 2)))

;; elli req record, etc
(include-lib "elli/include/elli.hrl")

;; lmug request record
(include-lib "lmug/include/request.lfe")

;; lmug response record
(include-lib "lmug/include/response.lfe")


;; TODO: set up handle/2, etc
;;       handler/2 should take an lmug request and a some options,
;;       and return an lmug response record.
;; TODO: write docstring
(defun run (handler opts) 'undefined)

;; TODO: elli_handler:handle/2, wrapping the handler/2 passed to run/2.
;; TODO: write docstring
(defun handle (req args) 'undefined)

;; TODO: implement
;; TODO: write docstring
(defun elli->request (req args)
  "Given an elli req, return an lmug request."
  'undefined)

;; TODO: implement
;; TODO: write docstring
(defun response->elli (req args)
  "Given an lmug response, return an elli response."
  'undefined)
