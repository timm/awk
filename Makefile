# vim: ts=2 sw=2 noet
SHELL    := /bin/bash
GIT_ROOT := $(shell git rev-parse --show-toplevel 2>/dev/null)
ETC      := $(GIT_ROOT)/etc

CLS     := '\033[H\033[J'
cRESET  := '\033[0m'
cYELLOW := '\033[1;33m'

export PATH := $(CURDIR):$(PATH)

DATA ?= $(HOME)/gits/moot/classify/soybean.csv

GAWK_BASE = gawk \
  -f <(dot dot.awk) \
  -f <(dot numsym.awk) \
  -f <(dot data.awk)

GAWK    = $(GAWK_BASE) -f <(dot tree.awk)
GAWK_NB = $(GAWK_BASE) -f <(dot bayes.awk)

CFG    = <(printf 'wait,400\nleaf,4\nmaxd,8\n')
CFG20  = <(printf 'wait,500\nleaf,4\nmaxd,8\n')
CFG_NB = <(printf 'wait,500\nm,1\nk,1\n')

SHUF = shuf(){ gawk -v seed=$${1:-$$RANDOM} -f shuf.awk "$$2"; }

help: ## show help
	@awk 'BEGIN{FS=":.*##"} \
	      /^[a-zA-Z_%\/.~$$-]+:.*##/ \
	      {printf "  \033[36m%-20s\033[0m %s\n",$$1,$$2}' \
	      $(MAKEFILE_LIST)

push: ## commit with prompted msg and push
	@read -p "Reason? " msg; \
	 git commit -am "$$msg"; git push; git status

pull: ## update from main
	git pull

sh: ## launch dev shell (banner + etc/bash.rc)
	@-echo -e $(CLS)$(cYELLOW); figlet -W -f slant awk; \
	  echo -e $(cRESET)
	@-bash --init-file $(ETC)/bash.rc -i

lint: ## lint f=x.awk
	@gawk --lint --source 'BEGIN{}' -f $f </dev/null

demo: ## tree demo on $(DATA)
	$(GAWK) $(CFG) $(DATA) | gawk -f metrics.awk

demo-raw: ## tree demo (no metrics)
	$(GAWK) $(CFG) $(DATA)

demo20: ## 20-shuffle tree demo with metrics
	@$(SHUF); for i in $$(seq 1 20); do \
	  $(GAWK) $(CFG20) <(shuf $$i $(DATA)); \
	done | gawk -f metrics.awk

nb20: ## 20-shuffle naive-bayes demo with metrics
	@$(SHUF); for i in $$(seq 1 20); do \
	  $(GAWK_NB) $(CFG_NB) <(shuf $$i $(DATA)); \
	done | gawk -f metrics.awk

show: ## show all source awk files
	@for f in dot.awk numsym.awk data.awk tree.awk bayes.awk; do \
	  echo "# === $$f ==="; dot $$f; done

~/tmp/%.pdf: %.awk $(MAKEFILE_LIST) ## .awk ==> .pdf
	@mkdir -p ~/tmp
	@echo "pdf-ing $@ ... "
	@a2ps -Br --quiet --landscape --chars-per-line=65 \
	      --lines-per-page=100 --line-numbers=1 --borders=no \
	      --pro=color --columns=3 -M letter \
	      -o - $< | ps2pdf - $@
	@open $@

.PHONY: help push pull sh lint demo demo-raw demo20 nb20 show
