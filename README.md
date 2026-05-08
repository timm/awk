# gawk tools

A collection of small gawk-based tools for data mining and machine learning experiments.

Each tool lives in its own subdirectory with its own Makefile and README.

## Tools

- [`dot/`](dot/) — decision-tree and naive-Bayes classifiers driven by simple `dot` source-loading.

## Layout

```
.
├── README.md
├── Makefile          # top-level: help, push, sh; delegates to tool dirs
├── docs/             # GitHub Pages source
├── data/             # shared CSVs
├── etc/              # shared dotfiles
└── <tool>/           # one subdir per tool
```

## Usage

```sh
make help         # list top-level targets
make -C dot help  # tool-specific targets
```
