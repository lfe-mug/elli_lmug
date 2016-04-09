(defmodule elli_lmug
  (doc "TODO: write docstring")
  (behaviour elli_handler)
  ;; elli_handler callbacks
  (export (handle 2))
  ;; elli <-> lmug translation
  (export (elli->request 1) (response->elli 1)))

(include-lib "elli_lmug/include/elli_lmug.hrl") ; elli req record, etc
(include-lib "lmug/include/request.lfe")        ; lmug request record
(include-lib "lmug/include/response.lfe")       ; lmug response record


;;;===================================================================
;;; elli_handler callbacks
;;;===================================================================

(defun handle
  ;; TODO: write docstring
  ([req ()]       'ignore)
  ([req handlers] (handle req (lmug:response) handlers)))


;;;===================================================================
;;; elli <-> lmug translation functions
;;;===================================================================

;; TODO: implement
(defun elli->request (req)
  "Given an [elli `#req{}`][1], return an [lmug `#request{}`][2].

  [1]: https://github.com/knutin/elli/blob/v1.0.5/include/elli.hrl#L35-L46
  [2]: https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md#request-record"
  (let (((list uri remote-addr path query-string
               query-params method headers body)
         (lc ((<- func (list #'elli_request:raw_path/1
                             #'elli_request:peer/1
                             #'elli_request:path/1
                             #'elli_request:query_str/1
                             #'elli_request:get_args_decoded/1
                             #'elli->method/1
                             #'elli_request:headers/1
                             #'elli_request:body/1)))
           (funcall func req))))
    (make-request
     ;; TODO: server-port
     ;; TODO: server-name
     ;; TODO: remote-addr
     uri          (binary_to_list uri) ; FIXME: drop the binary_to_list/1 call
     path         path
     query-string query-string
     query-params query-params
     ;; TODO: scheme
     method       method
     ;; TODO: protocol
     ;; TODO: ssl-client-cert
     headers       headers
     body          body
     ;; TODO: consider removing orig
     orig         req
     ;; TODO: mw-data
     )))

(defun response->elli
  "Given an [lmug `#response{}`][1], return an [elli response][2].

  [1]: https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md#response-record
  [2]: https://github.com/knutin/elli/blob/v1.0.5/src/elli_handler.erl#L5"
  ([(= (match-response status status headers headers body body) response)]
   ;; (tuple status headers body)
   ;; FIXME: delete this hack once lmug uses binaries
   (tuple status
          (lists:map
            (match-lambda
              ([`#(,k ,v)]
               `#(,(list_to_binary k) ,(list_to_binary v))))
            headers)
          (list_to_binary body))))


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun handle
  ;; TODO: write docstring
  ([req handler `[,module-opts . ,handlers]]
   (case module-opts
     (`#(,module ,opts) (when (is_atom module) (is_list opts))
      (if (erlang:function_exported module 'wrap 2)
        (handle req (call module 'wrap handler opts) handlers)
        'ignore))
     (_ 'ignore)))
  ([req handler []]
   (response->elli (funcall handler (elli->request req)))))

;; TODO: write docstring
(defun elli->method
  ([(match-req method method)] (elli->method method))
  (['OPTIONS]                  'options)
  (['GET]                      'get)
  (['HEAD]                     'head)
  (['POST]                     'post)
  (['PUT]                      'put)
  (['DELETE]                   'delete)
  (['TRACE]                    'trace)
  ([bin] (when (is_binary bin))
   ;; TODO: consider clj/pynchon
   (let ((bin* (bc ((<= c bin)) ((string:to_lower c) integer))))
     (binary_to_existing_atom bin* 'latin1))))
