SHELL := /bin/bash
export PATH := $(CURDIR):$(PATH)

DATA  ?= $(HOME)/gits/moot/classify/heart.c.csv

GAWK = gawk \
  -f <(dot dot.awk) \
  -f <(dot numsym.awk)

help: ## show help
	@awk 'BEGIN{FS=":.*##"} \
	      /^[a-zA-Z_%\/.~$$-]+:.*##/ \
	      {printf "  \033[36m%-12s\033[0m %s\n",$$1,$$2}' $(MAKEFILE_LIST)

hello: ## smallest example: running mean of stdin column 1
	@printf "10\n20\n30\n40\n50\n" \
	  | gawk -f <(dot dot.awk) -f <(dot hello.awk)

stats: ## per-column stats on $$DATA (numeric: mean/stdev; symbolic: mode/entropy)
	$(GAWK) -f <(dot stats.awk) $(DATA)

show: ## print all source files post-prep
	@for f in dot.awk numsym.awk stats.awk hello.awk; do \
	  echo "# === $$f ==="; dot $$f; done

.PHONY: help hello stats show
