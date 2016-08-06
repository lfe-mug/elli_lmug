(defmodule lmug-elli
  "Elli middleware to run an lmug app."
  (behaviour elli_handler)
  ;; (behaviour lmug-srvr)
  ;; elli_handler callbacks
  (export (handle 2))
  ;; (forthcoming) lmug-srvr callbacks
  (export (run 2)))

(include-lib "lmug_elli/include/lmug_elli.hrl") ; elli req record, etc
(include-lib "clj/include/compose.lfe")         ; threading macros


;;;===================================================================
;;; Elli handler
;;;===================================================================

(defun handle (req opts)
  (log "Got req" req)
  (->> req
       (lmug-elli-adptr:convert-request)
       (log "Request data")
       (lmug-elli-adptr:call-handler)
       (log "Handler data")
       (lmug-elli-adptr:convert-response)
       (log "Response data")))


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
