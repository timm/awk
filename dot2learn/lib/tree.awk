# tree.awk -- decision/regression tree (binary, ezr-style). Heap-free.
# Tree(n, d, rows, dep, label)  -- constructor: builds tree node into n.
# Tree_walk(d, n, row)          -- returns leaf mu directly (scalar).
# Tree_score_row(d, r)          -- prints "pred,actual" for row r.

function Tree_score_row(d, r,    pred, actual) {
  if (!d.has_tree) { Tree(d.tree, d, d.all, 0, ""); d.has_tree = 1 }
  pred   = Tree_walk(d, d.tree, d.rows[r])
  actual = y_eval(d, d.rows[r])
  print pred "," actual }

# --- target evaluation: regression disty OR classification klass ----
function y_eval(d, row) {
  return (d.ykind == "Num") ? disty(d, row) : row[d.klass] }

# polymorphic y-column over a row-id set. y is out-param.
function ycol(d, rows, y,    r) {
  mk(y, d.ykind)
  for (r in rows) add(y, y_eval(d, d.rows[rows[r]]), 1) }

function Tree_spread(d, rows,    y, v) {
  ycol(d, rows, y); v = var(y); return v }

function Tree_leaf_pred(d, rows,    y, v) {
  ycol(d, rows, y); v = mid(y); return v }

# for each y-col, compute mean over rows, store in n.ymids[name].
function Tree_ymids(d, rows, n,    i, rr, c, name) {
  for (i in d.y) {
    name = d.hdr[i]
    delete c
    mk(c, d.nump[i] ? "Num" : "Sym")
    for (rr in rows) add(c, d.rows[rows[rr]][i], 1)
    n.ymids[name] = mid(c) } }

# --- candidate cuts for one column ---------------------------------
# numeric -> [median];  symbolic -> [each distinct value]
function Tree_cuts(d, c, rows, out,   vs, seen, n, r, x, tmp, i) {
  n = 0
  if (d.cols[c].is == "Num") {
    for (r in rows) {
      x = d.rows[rows[r]][c]
      if (x != "?") vs[++n] = x }
    if (n == 0) return 0
    for (i = 1; i <= n; i++) tmp[i] = vs[i]
    isort_n(tmp, n)
    out[1] = tmp[int((n+1)/2)]
    return 1 }
  for (r in rows) {
    x = d.rows[rows[r]][c]
    if (x == "?" || (x in seen)) continue
    seen[x] = 1; out[++n] = x }
  return n }

function fmt_num(v) {
  return (v == int(v)) ? sprintf("%d", v) : sprintf("%.3f", v) }

function isort_n(a, n,   i, j, key) {
  for (i = 2; i <= n; i++) {
    key = a[i]; j = i - 1
    while (j >= 1 && a[j] > key) { a[j+1] = a[j]; j-- }
    a[j+1] = key } }

# --- one binary split: build l[], r[] of row-ids, return weighted spread.
# missing values go LEFT (with the cut side).
function Tree_try_split(d, c, cut, rows, l, r,
                        sym, i, rid, x, ly, ry, ll, rl, score) {
  sym = (d.cols[c].is == "Sym")
  ll = 0; rl = 0
  for (i in rows) {
    rid = rows[i]; x = d.rows[rid][c]
    if (x == "?" || (sym ? x == cut : x <= cut)) l[++ll] = rid
    else                                         r[++rl] = rid }
  if (ll == 0 || rl == 0) return -1
  ycol(d, l, ly); ycol(d, r, ry)
  score = ly.n * var(ly) + ry.n * var(ry)
  return score }

# --- tree constructor: builds node into n (out-param) --------------
function Tree(n, d, rows, dep, label,
              c, cuts, ci, cut, lr, rr, score, kind,
              bestS, bestC, bestCut, bestL, bestR, key) {
  new(n, "Tree")
  n.label = (label == "" ? "ROOT" : label)
  n.dep   = dep
  n.mu    = Tree_leaf_pred(d, rows)
  n.nrows = length(rows)
  Tree_ymids(d, rows, n)
  if (length(rows) < 2 * THE.leaf || dep >= THE.maxd) {
    n.kind = "leaf"; return }
  bestS = 1e30; bestC = 0
  for (c = 1; c <= d.nc; c++) {
    if ((c in d.y) || c == d.klass) continue
    delete cuts
    if (!Tree_cuts(d, c, rows, cuts)) continue
    for (ci = 1; ci <= length(cuts); ci++) {
      cut = cuts[ci]
      delete lr; delete rr
      score = Tree_try_split(d, c, cut, rows, lr, rr)
      if (score < 0) continue
      if (length(lr) < THE.leaf || length(rr) < THE.leaf) continue
      if (score < bestS) {
        bestS = score; bestC = c; bestCut = cut
        delete bestL; delete bestR
        for (key in lr) bestL[key] = lr[key]
        for (key in rr) bestR[key] = rr[key] } } }
  if (!bestC) { n.kind = "leaf"; return }
  n.kind = "branch"; n.col = bestC; n.cut = bestCut
  kind = d.cols[bestC].is
  if (kind == "Num") {
    Tree(n.kids.lo, d, bestL, dep+1,
      sprintf("%s <= %s", d.hdr[bestC], fmt_num(bestCut)))
    Tree(n.kids.hi, d, bestR, dep+1,
      sprintf("%s >  %s", d.hdr[bestC], fmt_num(bestCut)))
  } else {
    Tree(n.kids.yes, d, bestL, dep+1,
      d.hdr[bestC] " == " bestCut)
    Tree(n.kids.no, d, bestR, dep+1,
      d.hdr[bestC] " != " bestCut) } }

# walk to leaf, return mu directly.
function Tree_walk(d, n, row,    c, x, kind, key) {
  if (n.kind == "leaf") return n.mu
  c = n.col;  x = row[c]
  kind = d.cols[c].is
  if (x == "?") key = (kind == "Num") ? "lo" : "yes"
  else if (kind == "Num") key = (x <= n.cut ? "lo" : "hi")
  else                    key = (x == n.cut ? "yes" : "no")
  if (!(key in n.kids)) return n.mu
  return Tree_walk(d, n.kids[key], row) }
