# bayes-cli.awk -- CLI rules for Naive Bayes train/test.

BEGIN { FS = " *, *" }

FNR == NR { THE[$1] = $2 + 0; next }

FNR == 1 { Data(D); Data_head(D, $0); next }

{
  if (FNR - 1 <= THE.wait) Nb_train(D, Data_read(D, 1))
  else                     Nb_test(D, Data_read(D, 0)) }

END { rogues() }
