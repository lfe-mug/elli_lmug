(defmodule lmug-elli
  (doc "TODO: write docstring")
  (behaviour elli_handler)
  ;; elli_handler callbacks
  (export (handle 2))
  ;; elli <-> lmug translation
  (export (elli->request 1) (response->elli 1)))

(include-lib "lmug_elli/include/lmug_elli.hrl") ; elli req record, etc
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

(defun elli->request (req)
  "Given an [elli `#req{}`][1], return an [lmug `#request{}`][2].

  [1]: https://github.com/knutin/elli/blob/v1.0.5/include/elli.hrl#L35-L46
  [2]: https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md#request-record"
  (let (((list `#(,server-port ,server-name) remote-addr uri path
               query-string query-params scheme method protocol
               headers body)
         (lc ((<- func (list #'elli->port-name/1
                             #'elli_request:peer/1
                             #'elli_request:raw_path/1
                             #'elli_request:path/1
                             #'elli_request:query_str/1
                             #'elli_request:get_args_decoded/1
                             #'elli->scheme/1
                             #'elli->method/1
                             #'elli->protocol/1
                             #'elli_request:headers/1
                             #'elli_request:body/1)))
           (funcall func req))))
    (make-request server-port  server-port
                  server-name  server-name
                  remote-addr  remote-addr
                  uri          uri
                  path         path
                  query-string query-string
                  query-params query-params
                  scheme       scheme
                  method       method
                  protocol     protocol
                  ;; TODO: ssl-client-cert
                  headers       headers
                  body          body
                  orig         req
                  mw-data      [])))

(defun response->elli
  "Given an [lmug `#response{}`][1], return an [elli response][2].

  [1]: https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md#response-record
  [2]: https://github.com/knutin/elli/blob/v1.0.5/src/elli_handler.erl#L5"
  ([(= (match-response status status headers headers body body) response)]
   (tuple status headers body)))


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

(defun elli->port-name
  ;; TODO: write docstring
  ([(match-req headers headers)]
   (case (binary:split (proplists:get_value #"Host" headers) #":")
     (`[,name ,port] `#(,(binary_to_integer port) ,name))
     (`[,name]       `#(80    ,name))
     ;; FIXME: obviously
     (_              (error 'FIXME)))))

(defun elli->scheme
  ;; TODO: write docstring
  ([(match-req socket `#(plain ,_socket))] 'http)
  ([(match-req socket `#(ssl   ,_socket))] 'https))

(defun elli->protocol
  ;; TODO: write docstring
  ([(match-req version `#(,major ,minor))]
   (flet ((i->l (i) (integer_to_list i)))
     (iolist_to_binary (list "HTTP/" (i->l major) "." (i->l minor))))))

(defun elli->method
  ;; TODO: write docstring
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
