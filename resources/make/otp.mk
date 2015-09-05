NODENAME=$(shell echo "lupyter"|sed -e 's/-//g')

dev:
	@echo "Running OTP app in the foreground ..."
	@ERL_LIBS=$(ERL_LIBS) PATH=$(SCRIPT_PATH) lfe \
	-s 'lupyter-app'

run: dev

dev-named:
	@echo "Running OTP app in the foreground ..."
	@ERL_LIBS=$(ERL_LIBS) PATH=$(SCRIPT_PATH) lfe \
	-sname repl@${HOST} -setcookie `cat ~/.erlang.cookie` \
	-s 'lupyter-app'

run-named: dev-named

prod:
	@echo "Running OTP app in the background ..."
	@ERL_LIBS=$(ERL_LIBS) PATH=$(SCRIPT_PATH) lfe \
	-sname ${NODENAME}@${HOST} -setcookie `cat ~/.erlang.cookie` \
	-s 'lupyter-app' -noshell -detached

daemon: prod

stop:
	@echo "Stopping OTP app ..."
	@ERL_LIBS=$(ERL_LIBS) PATH=$(SCRIPT_PATH) lfe \
	-sname controller@${HOST} -setcookie `cat ~/.erlang.cookie` \
	-eval "(rpc:call '${NODENAME}@${HOST} init stop '())" \
	-noshell -s erlang halt

list-nodes:
	@echo "Getting list of running OTP nodes ..."
	@echo
	@ERL_LIBS=$(ERL_LIBS) PATH=$(SCRIPT_PATH) lfe \
	-sname controller@${HOST} -setcookie `cat ~/.erlang.cookie` \
	-eval '(lfe_io:format "~p~n" (list (element 2 (net_adm:names))))' \
	-noshell -s erlang halt
