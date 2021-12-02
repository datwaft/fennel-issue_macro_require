; If you change :macro-module for :macro-module-standalone it works, because
; the function is included in the macro file.

; If you change :macro-module for :macro-module-as-macro it always prints
; "Bye", because x is always a symbol in compilation time.

(import-macros {: if-fn-hello-else-bye} :macro-module)

(print "These lines should print \"Hello\"")
(print "================================")
(print "")

(if-fn-hello-else-bye (fn [] nil)) ; This should print "Hello"
(if-fn-hello-else-bye #nil) ; This should also print "Hello"

(print "These lines should print \"Bye\"")
(print "==============================")
(print "")

(if-fn-hello-else-bye (+ 1 1)) ; This should print "Bye"
(if-fn-hello-else-bye "A nice string") ; This should also print "Bye"
(if-fn-hello-else-bye a-nice-symbol) ; This should also print "Bye"
