(defmodule lmug-elli
  "Elli middleware to run an lmug app."
  (behaviour elli_handler)
  ;; (behaviour lmug-srvr)
  ;; elli_handler callbacks
  (export (handle 2) (handle_event 3))
  ;; (forthcoming) lmug-srvr callbacks
  (export (run 2)))

(include-lib "lmug_elli/include/lmug_elli.hrl") ; elli req record, etc
(include-lib "clj/include/compose.lfe")         ; threading macros


;;;===================================================================
;;; Elli handler
;;;===================================================================

(defun handle (req opts)
  "Handle an [Elli `#req{}`][1] by converting it to an [lmug `#request{}`][2]
  ([[lmug-elli-adptr:convert-request/1]]), calling the specified handler
  ([[lmug-elli-adptr:call-handler/1]]) and then converting the
  [lmug `#response{}`][3] to an [Elli response tuple][4].

  [1]: https://github.com/knutin/elli/blob/v1.0.5/include/elli.hrl#L35-L46
  [2]: https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md#request-record
  [3]: https://github.com/lfe-mug/lmug/blob/master/docs/SPEC.md#response-record
  [4]: https://github.com/knutin/elli/blob/v1.0.5/src/elli_handler.erl#L5"
  (log "Got req" req)
  (->> req
       (lmug-elli-adptr:convert-request)
       (log "Request data")
       (lmug-elli-adptr:call-handler)
       (log "Handler data")
       (lmug-elli-adptr:convert-response)
       (log "Response data")))

(defun handle_event (_event _data _args)
  "Handle request events, like `request_complete`, `request_throw`,
  `client_timeout`, etc. Included for [`elli_handler`][1] conformance.
  Return ``'ok``, irrespective of input.

  [1]: https://github.com/knutin/elli/blob/v1.0.5/src/elli_handler.erl"
  'ok)


;;;===================================================================
;;; lmug server
;;;===================================================================

(defun run (handler opts)
  ;; TODO: write docstring
  (logjam:start)
  ;; FIXME: rethink this
  (let* ((config      `[#(mods [#(lmug-elli [#(handler ,handler)])])])
         (`#(ok ,pid) (elli:start_link (list* #(callback       elli_middleware)
                                              `#(callback_args ,config)
                                              opts))))
    (unlink pid)
    (logjam:info "Application elli started at pid ~p" `[,pid])
    (receive
      (`#(EXIT ,id ,_) (when (=:= pid id)) 'ok)
      (after 0 'ok))
    (list pid)))


;;;===================================================================
;;; Internal functions
;;;===================================================================

(defun log (msg data) (logjam:debug (++ msg ":\n~p") `[,data]) data)
