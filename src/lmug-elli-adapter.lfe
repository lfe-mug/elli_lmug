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
  ;; TODO: get some values from initial run/2 call

  (let* ((uri  (binary_to_list (elli_request:raw_path req)))
         (path (uri->path uri))
         (request-method (method-elli->lmug (elli_request:method req))))
    (make-request server-port    (error 'TODO)
                  server-name    (error 'TODO)
                  remote-addr    (error 'TODO)
                  uri            uri
                  path           path
                  ;; XXX args :: [{binary(), any()}]
                  query-params   (elli_request:get_args_decoded req)
                  scheme         (error 'TODO)
                  request-method request-method
                  body           (error 'TODO)
                  orig           (error 'TODO))))

(defun uri->path (uri)
  (case (string:tokens uri "?")
    (`[,path]       path)
    (`[,path ,args] path)))

;; TODO: implement
;; TODO: write docstring
(defun response->elli (req args)
  "Given an lmug response, return an elli response."
  'undefined)

;; TODO: write docstring
(defun method-elli->lmug
  (['OPTIONS] 'options)
  (['GET]     'get)
  (['HEAD]    'head)
  (['POST]    'post)
  (['PUT]     'put)
  (['DELETE]  'delete)
  (['TRACE]   'trace)
  ([bin] (when (is_binary bin))
   ;; TODO: make sure all the right atoms exist
   (binary_to_existing_atom (bc ((<= c bin)) ((string:to_lower c) integer))
                            'latin1)))
