SHELL := /bin/bash

DOT_DIR := $(abspath $(CURDIR)/../dot)
export PATH := $(DOT_DIR):$(CURDIR):$(PATH)

DATA  ?= $(HOME)/gits/moot/optimize/misc/auto93.csv
CLASS ?= $(HOME)/gits/moot/classify/heart.c.csv

BASE = gawk \
  -f <(dot $(DOT_DIR)/dot.awk) \
  -f <(dot $(DOT_DIR)/numsym.awk) \
  -f <(dot data.awk) \
  -f <(dot dist.awk)

GAWK_TR = $(BASE) -f <(dot tree.awk) -f <(dot tree-cli.awk)
GAWK_NB = $(BASE) -f <(dot bayes.awk) -f <(dot bayes-cli.awk)
GAWK_AC = $(BASE) -f <(dot tree.awk) -f <(dot treeshow.awk) \
                  -f <(dot wins.awk) -f <(dot active.awk)

CFG_TR = <(printf 'wait,200\nleaf,4\nmaxd,8\np,2\n')
CFG_NB = <(printf 'wait,200\nm,1\nk,1\n')
CFG_AC = <(printf 'seed,1\np,2\nfew,128\nstart,4\nbudget,50\ncheck,5\nleaf,3\nmaxd,8\n')

SHUF = shuf(){ gawk -v seed=$${1:-$$RANDOM} -f shuf.awk "$$2"; }

help: ## show help
	@awk 'BEGIN{FS=":.*##"} \
	      /^[a-zA-Z_%\/.~$$-]+:.*##/ \
	      {printf "  \033[36m%-12s\033[0m %s\n",$$1,$$2}' $(MAKEFILE_LIST)

# --- 3 high-level apps ---

tree: ## decision/regression tree on $$DATA
	$(GAWK_TR) $(CFG_TR) $(DATA) | gawk -f metrics.awk

nb: ## naive Bayes on $$CLASS
	$(GAWK_NB) $(CFG_NB) $(CLASS) | gawk -f metrics.awk

acquire: ## active learning on $$DATA: warm-start, acquire, tree, score
	$(GAWK_AC) $(CFG_AC) $(DATA)

# --- variants ---

tree-raw: ## tree on $$DATA, raw "pred,actual" lines
	$(GAWK_TR) $(CFG_TR) $(DATA)

tree20: ## 20 shuffled splits, averaged metrics (tree)
	@$(SHUF); for i in $$(seq 1 20); do \
	  $(GAWK_TR) $(CFG_TR) <(shuf $$i $(DATA)); \
	done | gawk -f metrics.awk

nb20: ## 20 shuffled splits, averaged metrics (nb)
	@$(SHUF); for i in $$(seq 1 20); do \
	  $(GAWK_NB) $(CFG_NB) <(shuf $$i $(CLASS)); \
	done | gawk -f metrics.awk

show: ## print all source files post-prep
	@for f in data.awk dist.awk \
	          tree.awk tree-cli.awk treeshow.awk \
	          bayes.awk bayes-cli.awk \
	          wins.awk active.awk; do \
	  echo "# === $$f ==="; dot $$f; done

.PHONY: help tree nb acquire tree-raw tree20 nb20 show
