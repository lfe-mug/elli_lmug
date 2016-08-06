(defmodule lmug-elli-adptr
  "An lmug adaptor for the Elli web server."
  (behaviour lmug-adptr)
  ;; lmug-adptr callbacks
  (export (call-handler 1) (call-handler 2)
          (convert-request 1) (convert-request 2)
          (convert-response 1) (convert-response 2))
  ;; Convenient imports
  (import (rename elli_request
            ((peer 1) convert-remote-addr)
            ((raw_path 1) convert-uri)
            ((path 1) convert-path)
            ((query_str 1) convert-query-string)
            ((get_args_decoded 1) convert-query-params)
            ((headers 1) convert-headers)
            ((body 1) convert-body))))

(include-lib "lmug_elli/include/lmug_elli.hrl") ; elli req record, etc
(include-lib "clj/include/compose.lfe")         ; threading macros
(include-lib "lmug/include/request.lfe")        ; lmug request record
(include-lib "lmug/include/response.lfe")       ; lmug response record


;;;===================================================================
;;; lmug-adptr callbacks
;;;===================================================================

(defun call-handler (request)
  "Equivalent to [[call-handler/2]] with the empty list as `opts`."
  (call-handler request []))

(defun call-handler
  "Given an lmug `request`, call the specified handler on it and
  return the resultant `response`.

  If the handler cannot be found, return `` 'ignore ``.

  N.B. `opts` is currently ignored."
  ([(= (match-request method method uri uri orig req) request) _opts]
   (let* ((`#(elli_middleware ,callback-args) (req-callback req))
          (mods           (proplists:get_value 'mods callback-args []))
          (lmug-elli-opts (proplists:get_value 'lmug-elli mods [])))
     (case (proplists:get_value 'handler lmug-elli-opts)
       ;; TODO: Throw an error re: missing handler?
       ('undefined 'ignore)
       (handler    (funcall handler request))))))

(defun convert-request (req)
  "Equivalent to [[convert-request/2]] with the empty list as `opts`."
  (convert-request req []))

(defun convert-request (req _opts)
  "Given an [elli `#req{}`][1], return an [lmug `#request{}`][2].

  N.B. `opts` is currently ignored.

  [1]: https://github.com/knutin/elli/blob/v1.0.5/include/elli.hrl#L35-L46
  [2]: https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md#request-record"
  (let (((list `#(,server-port ,server-name) remote-addr uri path
               query-string query-params scheme method protocol
               headers body)
         (lc ((<- func (list #'convert-port-name/1
                             #'convert-remote-addr/1
                             #'convert-uri/1
                             #'convert-path/1
                             #'convert-query-string/1
                             #'convert-query-params/1
                             #'convert-scheme/1
                             #'convert-method/1
                             #'convert-protocol/1
                             #'convert-headers/1
                             #'convert-body/1)))
           (funcall func req))))
    (log "Converting elli req" req)
    (make-request server-port  server-port
                  server-name  server-name
                  remote-addr  remote-addr
                  uri          uri
                  path         path
                  query-string query-string
                  query-params query-params
                  scheme       scheme
                  method       method
                  ;; protocol     protocol
                  ;; TODO: ssl-client-cert
                  headers       headers
                  body          body
                  orig         req
                  ;; TODO: add mw-data field to lmug request record
                  ;; mw-data      []
                  )))

(defun convert-response (req)
  "Equivalent to [[convert-response/2]] with the empty list as `opts`."
  (convert-response req []))

(defun convert-response
  "Given an [lmug `#response{}`][1], return an [elli response][2].

  [1]: https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md#response-record
  [2]: https://github.com/knutin/elli/blob/v1.0.5/src/elli_handler.erl#L5"
  ([(= (match-response status status headers headers body body) response) _opts]
   (log "Converting elli response" response)
   (tuple status headers body)))


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun convert-port-name
  ;; TODO: write docstring
  ([(= (match-req headers headers) req)]
   (case (binary:split (proplists:get_value #"Host" headers) #":")
     (`[,name ,port]
      `#(,(binary_to_integer port) ,name))
     (`[,name]
      (case (convert-scheme req)
        ('http  `#(80  ,name))
        ('https `#(443 ,name))))
     ;; FIXME: obviously
     (_
      (error 'FIXME)))))

(defun convert-scheme
  ;; TODO: write docstring
  ([(match-req socket `#(plain ,_socket))] 'http)
  ([(match-req socket `#(ssl   ,_socket))] 'https))

(defun convert-protocol
  ;; TODO: write docstring
  ([(match-req version `#(,major ,minor))]
   (flet ((i->l (i) (integer_to_list i)))
     (iolist_to_binary (list "HTTP/" (i->l major) "." (i->l minor))))))

;; TODO: Use lmug-util:convert-verb/1 once it's ready.
(defun convert-method
  ;; TODO: write docstring
  ([(match-req method method)] (convert-method method))
  ([method]                    (lmug-util:convert-verb method)))

(defun log (msg data) (logjam:debug (++ msg ":\n~p") `[,data]) data)
