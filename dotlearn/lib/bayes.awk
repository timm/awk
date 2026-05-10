# bayes.awk -- Naive Bayes functions.
# requires: dot.awk, numsym.awk, data.awk

function nb_train(d, r,    lbl, i) {
  lbl = .d.rows[r][.d.klass]
  N[lbl]++
  if (!(lbl in HAVE)) {
    HAVE[lbl] = 1
    for (i = 1; i <= .d.nc; i++)
      if (i != .d.klass) COL[lbl][i] = new(.d.nump[i] ? "num" : "sym") }
  for (i = 1; i <= .d.nc; i++)
    if (i != .d.klass) add(COL[lbl][i], .d.rows[r][i], 1) }

function nb_test(d, r,    pred, actual) {
  pred   = nb_pred(d, .d.rows[r])
  actual = .d.rows[r][.d.klass]
  print pred "," actual }

function nb_pred(d, row,    lbl, i, ll, best, blbl, total, prior, nc, first) {
  for (lbl in N) { total += N[lbl]; nc++ }
  first = 1
  for (lbl in N) {
    prior = (N[lbl] + THE.k) / (total + THE.k * nc)
    ll = log(prior)
    for (i = 1; i <= .d.nc; i++) {
      if (i == .d.klass) continue
      ll += log(nb_safe_like(COL[lbl][i], row[i], prior)) }
    if (first || ll > best) { best = ll; blbl = lbl; first = 0 } }
  return blbl }

function nb_safe_like(c, x, prior,    v) {
  v = like(c, x, prior, THE.m)
  return v > 1e-30 ? v : 1e-30 }
