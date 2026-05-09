# vim: ts=2 sw=2 noet
SHELL    := /bin/bash
GIT_ROOT := $(shell git rev-parse --show-toplevel 2>/dev/null)
ETC      := $(GIT_ROOT)/etc

CLS     := '\033[H\033[J'
cRESET  := '\033[0m'
cYELLOW := '\033[1;33m'

TOOLS := dot dotlearn

help: ## show help
	@awk 'BEGIN{FS=":.*##"} \
	      /^[a-zA-Z_%\/.~$$-]+:.*##/ \
	      {printf "  \033[36m%-20s\033[0m %s\n",$$1,$$2}' \
	      $(MAKEFILE_LIST)

push: ## commit with prompted msg and push
	@read -p "Reason? " msg; \
	 git commit -am "$$msg"; git push; git status

pull: ## update from origin
	git pull

sh: ## launch dev shell (banner + etc/bash.rc if present)
	@-echo -e $(CLS)$(cYELLOW); figlet -W -f slant awk; \
	  echo -e $(cRESET)
	@-bash --init-file $(ETC)/bash.rc -i

dot: ## run dot/ default target
	$(MAKE) -C dot stats

dotlearn: ## run dotlearn/ default target
	$(MAKE) -C dotlearn demo

$(TOOLS:%=%-help): %-help: ## show <tool>'s help
	$(MAKE) -C $* help

.PHONY: help push pull sh dot dotlearn $(TOOLS:%=%-help)
