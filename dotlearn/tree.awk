# tree.awk -- decision/regression tree (binary, ezr-style).
# requires: dot.awk, numsym.awk, data.awk, dist.awk

function score_row(d, r,    pred, actual) {
  if (!.d.tree) .d.tree = tree_train(d, .d.all, 0, "")
  pred   = tree_test(d, .d.tree, .d.rows[r])
  actual = y_eval(d, .d.rows[r])
  print pred "," actual }

# --- target evaluation: regression disty OR classification klass ----
function y_eval(d, row) {
  return (.d.ykind == "num") ? disty(d, row) : row[.d.klass] }

# polymorphic y-column over a row-id set
function ycol(d, rows,    y, r) {
  y = new(.d.ykind)
  for (r in rows) add(y, y_eval(d, .d.rows[rows[r]]), 1)
  return y }

function spread(d, rows,    y, v) {
  y = ycol(d, rows); v = var(y); free(y); return v }

function leaf_pred(d, rows,    y, v) {
  y = ycol(d, rows); v = mid(y); free(y); return v }

# for each y-col, compute mean over rows, store in .n.ymids[name].
function ymids(d, rows, n,   i, rr, c, name) {
  for (i in .d.y) {
    name = .d.hdr[i]
    c    = new(.d.nump[i] ? "num" : "sym")
    for (rr in rows) add(c, .d.rows[rows[rr]][i], 1)
    .n.ymids[name] = mid(c)
    free(c) } }

# --- candidate cuts for one column ---------------------------------
# numeric -> [median];  symbolic -> [each distinct value]
function tree_cuts(d, c, rows, out,   k, vs, seen, n, r, x, tmp, i) {
  k = .d.cols[c]; n = 0
  if (.k.is == "num") {
    for (r in rows) {
      x = .d.rows[rows[r]][c]
      if (x != "?") vs[++n] = x }
    if (n == 0) return 0
    for (i = 1; i <= n; i++) tmp[i] = vs[i]
    isort_n(tmp, n)
    out[1] = tmp[int((n+1)/2)]
    return 1 }
  for (r in rows) {
    x = .d.rows[rows[r]][c]
    if (x == "?" || (x in seen)) continue
    seen[x] = 1; out[++n] = x }
  return n }

# integer if value is whole, else 3 decimals.
function fmt_num(v) {
  return (v == int(v)) ? sprintf("%d", v) : sprintf("%.3f", v) }

# in-place ascending sort of a[1..n]
function isort_n(a, n,   i, j, key) {
  for (i = 2; i <= n; i++) {
    key = a[i]; j = i - 1
    while (j >= 1 && a[j] > key) { a[j+1] = a[j]; j-- }
    a[j+1] = key } }

# --- one binary split: build l[], r[] of row-ids, return weighted spread.
# missing values go LEFT (with the cut side).
function try_split(d, c, cut, rows, l, r,
                   k, sym, i, rid, x, ly, ry, ll, rl, score) {
  k = .d.cols[c]; sym = (.k.is == "sym")
  ll = 0; rl = 0
  for (i in rows) {
    rid = rows[i]; x = .d.rows[rid][c]
    if (x == "?" || (sym ? x == cut : x <= cut)) l[++ll] = rid
    else                                         r[++rl] = rid }
  if (ll == 0 || rl == 0) return -1
  ly    = ycol(d, l); ry = ycol(d, r)
  score = .ly.n * var(ly) + .ry.n * var(ry)
  free(ly); free(ry)
  return score }

# --- tree -----------------------------------------------------------
function tree_train(d, rows, dep, label,
                    n, c, k, cuts, ci, cut, lr, rr, score,
                    bestS, bestC, bestCut, bestL, bestR, key, op) {
  n = new("node")
  .n.label = (label == "" ? "ROOT" : label)
  .n.dep   = dep
  .n.mu    = leaf_pred(d, rows)
  .n.nrows = length(rows)
  ymids(d, rows, n)
  if (length(rows) < 2 * THE.leaf || dep >= THE.maxd) {
    .n.kind = "leaf"; return n }
  bestS = 1e30; bestC = 0
  for (c = 1; c <= .d.nc; c++) {
    if ((c in .d.y) || c == .d.klass) continue
    delete cuts
    if (!tree_cuts(d, c, rows, cuts)) continue
    for (ci = 1; ci <= length(cuts); ci++) {
      cut = cuts[ci]
      delete lr; delete rr
      score = try_split(d, c, cut, rows, lr, rr)
      if (score < 0) continue
      if (length(lr) < THE.leaf || length(rr) < THE.leaf) continue
      if (score < bestS) {
        bestS = score; bestC = c; bestCut = cut
        delete bestL; delete bestR
        for (key in lr) bestL[key] = lr[key]
        for (key in rr) bestR[key] = rr[key] } } }
  if (!bestC) { .n.kind = "leaf"; return n }
  .n.kind = "branch"; .n.col = bestC; .n.cut = bestCut
  k = .d.cols[bestC]
  if (.k.is == "num") {
    .n.kids["lo"] = tree_train(d, bestL, dep+1,
      sprintf("%s <= %s", .d.hdr[bestC], fmt_num(bestCut)))
    .n.kids["hi"] = tree_train(d, bestR, dep+1,
      sprintf("%s >  %s", .d.hdr[bestC], fmt_num(bestCut)))
  } else {
    .n.kids["yes"] = tree_train(d, bestL, dep+1,
      .d.hdr[bestC] " == " bestCut)
    .n.kids["no"]  = tree_train(d, bestR, dep+1,
      .d.hdr[bestC] " != " bestCut) }
  return n }

function tree_test(d, n, row,    leaf) {
  leaf = tree_leaf(d, n, row)
  return .leaf.mu }

function tree_leaf(d, n, row,    c, x, k, key) {
  if (.n.kind == "leaf") return n
  c = .n.col;  x = row[c]
  k = .d.cols[c]
  if (x == "?") key = (.k.is == "num") ? "lo" : "yes"
  else if (.k.is == "num") key = (x <= .n.cut ? "lo" : "hi")
  else                     key = (x == .n.cut ? "yes" : "no")
  if (!(key in .n.kids)) return n
  return tree_leaf(d, .n.kids[key], row) }
