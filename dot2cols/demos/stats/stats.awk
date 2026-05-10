# stats.awk -- read CSV, print per-column running stats.
# Numeric columns (UPPER first letter) -> n, mean, stdev.
# Symbolic columns (lower first letter) -> n, mode, entropy.

BEGIN { FS = " *, *" }

NR == 1 { header()  ; next }
      { ingest() }

function header(    i) {
  for (i = 1; i <= NF; i++) {
    NAME[i] = $i
    mk(COL[i], $i ~ /^[A-Z]/ ? "Num" : "Sym") } }

function ingest(    i) {
  for (i = 1; i <= NF; i++) add(COL[i], $i, 1) }

END { report(); rogues() }

function report(    i) {
  printf "%-22s %6s %12s %12s\n", "column", "n", "mid", "spread"
  for (i = 1; i <= length(NAME); i++) {
    if (COL[i].is == "Num")
      printf "%-22s %6d %12.3f %12.3f\n", NAME[i], COL[i].n, mid(COL[i]), var(COL[i])
    else
      printf "%-22s %6d %12s %12.3f\n",   NAME[i], COL[i].n, mid(COL[i]), var(COL[i]) } }
