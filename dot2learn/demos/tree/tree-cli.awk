# tree-cli.awk -- CLI rules for tree-based train/test.

BEGIN { FS = " *, *" }

FNR == NR { THE[$1] = $2 + 0; next }

FNR == 1 { Data(D); Data_head(D, $0); next }

{
  if (FNR - 1 <= THE.wait) Data_read(D, 1)
  else                     Tree_score_row(D, Data_read(D, 0)) }

END { rogues() }
