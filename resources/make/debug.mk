simple:
	jupyter-console --kernel=simple-kernel --no-confirm-exit --colors=Linux

simple-debug:
	jupyter-console --kernel=simple-kernel --no-confirm-exit --colors=Linux --Session.debug=True

clojure:
	jupyter-console --kernel=clojure --no-confirm-exit --colors=Linux

clojure-debug:
	jupyter-console --kernel=clojure --no-confirm-exit --colors=Linux --Session.debug=True

lfe-debug:
	jupyter-console --kernel=lfe --no-confirm-exit --colors=Linux --Session.debug=True
