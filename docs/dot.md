# dot

Decision-tree and naive-Bayes classifiers, sourced via a tiny `dot` shell wrapper.

## Files

| File          | Purpose                          |
|---------------|----------------------------------|
| `dot`         | bash wrapper: `gawk -f prep.awk` |
| `prep.awk`    | preprocesses source files         |
| `dot.awk`     | core helpers                      |
| `data.awk`    | CSV loading                       |
| `numsym.awk`  | numeric/symbolic column stats     |
| `tree.awk`    | decision tree                     |
| `bayes.awk`   | naive Bayes                       |
| `metrics.awk` | reporting                         |
| `shuf.awk`    | seeded shuffle                    |

## Usage

```sh
cd dot
make demo      # tree on default DATA
make tree20    # 20-shuffle tree + metrics
make nb20      # 20-shuffle naive-Bayes + metrics
make show      # cat all source files via dot wrapper
```

Override data file:

```sh
make demo DATA=$HOME/gits/moot/classify/diabetes.csv
```
