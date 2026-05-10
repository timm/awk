# tree-cli.awk -- CLI rules for tree-based train/test
# usage:
#   gawk -f <(dot dot.awk) -f <(dot numsym.awk) -f <(dot data.awk) \
#        -f <(dot dist.awk) -f <(dot tree.awk) -f <(dot tree-cli.awk) \
#        config.csv data.csv

BEGIN { FS = " *, *" }

FNR == NR { THE[$1] = $2 + 0; next }

FNR == 1 { D = new("data"); data_head(D, $0); next }

{
  if (FNR - 1 <= THE.wait) data_read(D, 1)
  else                     score_row(D, data_read(D, 0)) }

END { rogues() }
