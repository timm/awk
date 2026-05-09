# bayes-cli.awk -- CLI rules for Naive Bayes train/test.

BEGIN { FS = " *, *" }

FNR == NR { THE[$1] = $2 + 0; next }

FNR == 1 { D = new("data"); data_head(D, $0); next }

{
  if (FNR - 1 <= THE.wait) nb_train(D, data_read(D, 1))
  else                     nb_test(D, data_read(D, 0)) }

END { rogues() }
