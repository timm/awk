# active.awk -- active learning pipeline.
# requires: dot.awk, numsym.awk, data.awk, dist.awk, tree.awk, treeshow.awk, wins.awk
#
# Reads CSV, splits 50/50 train/test (after shuffle), caps train to THE.few,
# warm-starts with THE.start labels, acquires THE.budget more by centroid
# distance, trains a tree on labelled rows, shows it, then scores the
# top THE.check tree predictions on test data with wins().

BEGIN { FS = " *, *" }

FNR == NR { THE[$1] = $2 + 0; next }

FNR == 1 { D = new("data"); data_head(D, $0); next }

      { data_read(D, 1) }

END { srand(THE.seed); pipeline(D); rogues() }

# ------------------------------------------------------------------ #
# d  = full data (all rows, full-data col stats) — used for wins/percentiles.
# dt = train data (clone of d, fed only train rows) — used for acquire+tree
#      so col stats and disty/distx match what ezr sees.
function pipeline(d,    rows, train_ids, test_ids, dt, train, lab, best, rest, unlab,
                       BC, RC, n, half, T, W, ranked, here, score, i) {
  # 1. wins percentiles from full data (matches ezr's wins(d0)).
  W = new("wins"); wins_init(d, .d.all, W)
  printf "wins  lo=%.3f  med=%.3f  sd=%.3f\n", .W.lo, .W.med, .W.sd

  # 2. shuffle all row indices
  for (i in .d.all) rows[++n] = .d.all[i]
  shuffle(rows, n)

  # 3. split half train / half test
  half = int(n / 2)
  for (i = 1;      i <= half; i++) train_ids[i]       = rows[i]
  for (i = half+1; i <= n;    i++) test_ids[i - half] = rows[i]

  # 4. cap train pool to THE.few
  for (i = THE.few + 1; (i in train_ids); i++) delete train_ids[i]

  # 5. clone d, feed train rows only (col stats reflect train only)
  dt = data_clone(d)
  data_feed(dt, train_ids, d)
  for (i in .dt.all) train[i] = .dt.all[i]

  # 6. warm start + acquire loop on dt
  warm(dt, train, lab, best, rest, BC, RC, unlab)
  acquire(dt, lab, best, rest, BC, RC, unlab)

  # 7. tree on labelled (using dt -- train-only col stats)
  printf "\n=== TREE on %d labelled rows ===\n", length(lab)
  T = tree_train(dt, lab, 0, "")
  treeshow(dt, T)

  # 8. rank test rows by tree prediction. tree leaf walk uses dt's cols
  #    (for cut-type info), but the row values come straight from d.
  rank_test_with(dt, d, T, test_ids, ranked)

  # 9. of top THE.check predicted-best, pick row with min ACTUAL disty
  #    (computed via dt -- ezr does the same with d_train).
  here = best_of_with(dt, d, ranked, THE.check)

  # 10. score that row's full-data disty against full-data percentiles
  score = wins_score(d, .d.rows[here], W)

  printf "\n=== RESULT ===\n"
  printf "labelled  : %d   (start=%d, budget=%d)\n",
         length(lab), THE.start, THE.budget
  printf "test rows : %d\n", length(test_ids)
  printf "top %d guess actual-disty=%.3f  win=%d/100\n",
         THE.check, disty(d, .d.rows[here]), score }

# ------------------------------------------------------------------ #
function shuffle(a, n,    i, j, t) {
  for (i = n; i > 1; i--) {
    j = int(rand() * i) + 1
    t = a[i]; a[i] = a[j]; a[j] = t } }

# ------------------------------------------------------------------ #
function cols_new(d, target,    i) {
  for (i = 1; i <= .d.nc; i++)
    target[i] = new(.d.nump[i] ? "num" : "sym") }

function cols_addrow(d, target, row, w,    i) {
  for (i = 1; i <= .d.nc; i++) add(target[i], row[i], 1, w) }

# ------------------------------------------------------------------ #
function warm(d, pool, lab, best, rest, bc, rc, unlab,
              i, n, sqn, sortbuf) {
  cols_new(d, bc); cols_new(d, rc)
  # take first THE.start rows from pool as initial lab
  for (i = 1; i <= THE.start && (i in pool); i++) lab[i] = pool[i]
  # sort lab by disty ascending
  sort_by_disty(d, lab, sortbuf)
  # sqrt(|lab|) best rows -> best; remainder -> rest
  sqn = int(sqrt(length(lab))); if (sqn < 1) sqn = 1
  for (i = 1; i <= length(lab); i++) {
    if (i <= sqn) { best[i] = lab[i]; cols_addrow(d, bc, .d.rows[lab[i]], 1) }
    else          { rest[i-sqn] = lab[i]; cols_addrow(d, rc, .d.rows[lab[i]], 1) } }
  # unlab = pool[start+1 ..]
  n = 0
  for (i = THE.start + 1; (i in pool); i++) unlab[++n] = pool[i] }

# sort row-id array a in place by ascending disty(d, .d.rows[a[i]])
function sort_by_disty(d, a, buf,    i, j, n, idx, t) {
  n = length(a)
  for (i = 1; i <= n; i++) buf[i] = disty(d, .d.rows[a[i]])
  for (i = 1; i < n; i++) {
    idx = i
    for (j = i+1; j <= n; j++) if (buf[j] < buf[idx]) idx = j
    if (idx != i) {
      t = buf[i]; buf[i] = buf[idx]; buf[idx] = t
      t = a[i];   a[i]   = a[idx];   a[idx]   = t } } }

# ------------------------------------------------------------------ #
function acquire(d, lab, best, rest, bc, rc, unlab,
                 loop, pickk, mb, mr) {
  for (loop = 1; loop <= THE.budget; loop++) {
    if (length(unlab) == 0) break
    # build best/rest centroids as rows
    delete mb; delete mr
    mids(d, bc, mb)
    mids(d, rc, mr)
    # find unlab row with smallest score = distx(best) - distx(rest)
    pickk = pick_best(d, unlab, mb, mr)
    if (pickk == 0) break
    # add to lab + best, drop from unlab
    move_pick(d, unlab, pickk, lab, best, bc)
    cap_best(d, lab, best, rest, bc, rc) } }

function pick_best(d, unlab, mb, mr,   i, s, bestS, bestI, rid) {
  bestS = 1e30; bestI = 0
  for (i = 1; (i in unlab); i++) {
    rid = unlab[i]
    s = distx(d, .d.rows[rid], mb) - distx(d, .d.rows[rid], mr)
    if (s < bestS) { bestS = s; bestI = i } }
  return bestI }

function move_pick(d, unlab, ix, lab, best, bc,    rid, j) {
  rid = unlab[ix]
  # compact unlab
  for (j = ix; (j+1) in unlab; j++) unlab[j] = unlab[j+1]
  delete unlab[j]
  lab[length(lab)+1]   = rid
  best[length(best)+1] = rid
  cols_addrow(d, bc, .d.rows[rid], 1) }

function cap_best(d, lab, best, rest, bc, rc,    cap, sortbuf, worst_id) {
  cap = int(sqrt(length(lab))); if (cap < 1) cap = 1
  while (length(best) > cap) {
    # find row in best with worst (highest) disty -> evict to rest
    sort_by_disty(d, best, sortbuf)
    worst_id = best[length(best)]
    delete best[length(best)]
    cols_addrow(d, bc, .d.rows[worst_id], -1)
    rest[length(rest)+1] = worst_id
    cols_addrow(d, rc, .d.rows[worst_id], 1) } }

# ------------------------------------------------------------------ #
function rank_test_with(dt, d, t, test, ranked,    buf, i, j, n, leaf, idx, t1, t2) {
  n = length(test)
  for (i = 1; i <= n; i++) {
    leaf = tree_leaf(dt, t, .d.rows[test[i]])
    buf[i] = .leaf.mu
    ranked[i] = test[i] }
  for (i = 1; i < n; i++) {
    idx = i
    for (j = i+1; j <= n; j++) if (buf[j] < buf[idx]) idx = j
    if (idx != i) {
      t1 = buf[i]; buf[i] = buf[idx]; buf[idx] = t1
      t2 = ranked[i]; ranked[i] = ranked[idx]; ranked[idx] = t2 } } }

# ------------------------------------------------------------------ #
function best_of_with(dt, d, ranked, k,    i, lim, best_id, best_d, dy) {
  lim = (length(ranked) < k ? length(ranked) : k)
  best_d = 1e30; best_id = ranked[1]
  for (i = 1; i <= lim; i++) {
    dy = disty(dt, .d.rows[ranked[i]])
    if (dy < best_d) { best_d = dy; best_id = ranked[i] } }
  return best_id }
