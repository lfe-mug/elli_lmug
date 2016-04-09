(defmodule elli_lmug
  (doc "TODO: write docstring")
  (behaviour elli_handler)
  ;; elli_handler callbacks
  (export (handle 2))
  ;; elli <-> lmug translation
  (export (elli->request  2) (elli_to_request  2)
          (response->elli 2) (response_to_elli 2)))

(include-lib "elli_lmug/include/elli_lmug.hrl") ; elli req record, etc
(include-lib "lmug/include/request.lfe")        ; lmug request record
(include-lib "lmug/include/response.lfe")       ; lmug response record


;;;===================================================================
;;; elli_handler callbacks
;;;===================================================================

;; TODO: elli_handler:handle/2, wrapping the handler/2 passed to run/2.

(defun handle (_req _args)
  ;; TODO: write docstring
  'ignore)


;;;===================================================================
;;; elli <-> lmug translation functions
;;;===================================================================

;; TODO: implement
;; TODO: write docstring
(defun elli->request (req args)
  "Given an [elli `#req{}`][1], return an [lmug `#request{}`][2].

  [1]: https://github.com/knutin/elli/blob/v1.0.5/include/elli.hrl#L35-L46
  [2]: https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md#request-record"
  ;; TODO: get some values from initial run/2 call
  (let* ((uri    (binary_to_list (elli_request:raw_path req)))
         (path   (uri->path uri))
         (method (method-elli->lmug (elli_request:method req))))
    (make-request
     ;; TODO: server-port
     ;; TODO: server-name
     ;; TODO: remote-addr
     uri          uri
     path         path
     ;; TODO: query-string
     ;; XXX args :: [{binary(), any()}]
     query-params (elli_request:get_args_decoded req)
     ;; TODO: scheme
     method       method
     ;; TODO: content-type
     ;; TODO: content-length
     ;; TODO: content-encoding
     ;; TODO: ssl-client-cert
     ;; TODO: headers
     ;; TODO: body
     ;; TODO: orig
     )))

(defun elli_to_request (req args)
  "A more Erlang-friendly alias to [[elli->request/2]]."
  (elli->request req args))

;; TODO: implement
;; TODO: write docstring
(defun response->elli (_req _args)
  "Given an [lmug `#response{}`][1], return an [elli response][2].

  [1]: https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md#response-record
  [2]: https://github.com/knutin/elli/blob/v1.0.5/src/elli_handler.erl#L5"
  'ignore)

(defun response_to_elli (req args)
  "A more Erlang-friendly alias to [[response->elli/2]]."
  (response->elli req args))


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun uri->path (uri)
  (case (string:tokens uri "?")
    (`[,path]       path)
    (`[,path ,args] path)))

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
   ;; TODO: consider clj/pynchon
   (let ((bin* (bc ((<= c bin)) ((string:to_lower c) integer))))
     (binary_to_existing_atom bin* 'latin1))))
