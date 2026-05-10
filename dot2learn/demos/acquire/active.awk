# active.awk -- active learning pipeline. Heap-free port.
# Reads CSV, splits 50/50 train/test (after shuffle), caps train to THE.few,
# warm-starts with THE.start labels, acquires THE.budget more by centroid
# distance, trains a tree on labelled rows, shows it, then scores the
# top THE.check tree predictions on test data with Wins().

BEGIN { FS = " *, *" }

FNR == NR { THE[$1] = $2 + 0; next }

FNR == 1 { Data(D); Data_head(D, $0); next }

      { Data_read(D, 1) }

END { srand(THE.seed); pipeline(D); rogues() }

# ------------------------------------------------------------------ #
function pipeline(d,    rows, train_ids, test_ids, dt, train, lab, best, rest, unlab,
                       BC, RC, n, half, T, W, ranked, here, score, i) {
  Wins(W, d, d.all)
  printf "wins  lo=%.3f  med=%.3f  sd=%.3f\n", W.lo, W.med, W.sd

  for (i in d.all) rows[++n] = d.all[i]
  shuffle(rows, n)

  half = int(n / 2)
  for (i = 1;      i <= half; i++) train_ids[i]       = rows[i]
  for (i = half+1; i <= n;    i++) test_ids[i - half] = rows[i]

  for (i = THE.few + 1; (i in train_ids); i++) delete train_ids[i]

  Data_clone(dt, d)
  Data_feed(dt, train_ids, d)
  for (i in dt.all) train[i] = dt.all[i]

  warm(dt, train, lab, best, rest, BC, RC, unlab)
  acquire(dt, lab, best, rest, BC, RC, unlab)

  printf "\n=== TREE on %d labelled rows ===\n", length(lab)
  Tree(T, dt, lab, 0, "")
  Tree_show(dt, T)

  rank_test_with(dt, d, T, test_ids, ranked)
  here = best_of_with(dt, d, ranked, THE.check)
  score = Wins_score(d, d.rows[here], W)

  printf "\n=== RESULT ===\n"
  printf "labelled  : %d   (start=%d, budget=%d)\n",
         length(lab), THE.start, THE.budget
  printf "test rows : %d\n", length(test_ids)
  printf "top %d guess actual-disty=%.3f  win=%d/100\n",
         THE.check, disty(d, d.rows[here]), score }

# ------------------------------------------------------------------ #
function shuffle(a, n,    i, j, t) {
  for (i = n; i > 1; i--) {
    j = int(rand() * i) + 1
    t = a[i]; a[i] = a[j]; a[j] = t } }

# ------------------------------------------------------------------ #
function cols_new(d, target,    i) {
  for (i = 1; i <= d.nc; i++)
    mk(target[i], d.nump[i] ? "Num" : "Sym") }

function cols_addrow(d, target, row, w,    i) {
  for (i = 1; i <= d.nc; i++) add(target[i], row[i], 1, w) }

# ------------------------------------------------------------------ #
function warm(d, pool, lab, best, rest, bc, rc, unlab,
              i, n, sqn, sortbuf) {
  cols_new(d, bc); cols_new(d, rc)
  for (i = 1; i <= THE.start && (i in pool); i++) lab[i] = pool[i]
  sort_by_disty(d, lab, sortbuf)
  sqn = int(sqrt(length(lab))); if (sqn < 1) sqn = 1
  for (i = 1; i <= length(lab); i++) {
    if (i <= sqn) { best[i] = lab[i]; cols_addrow(d, bc, d.rows[lab[i]], 1) }
    else          { rest[i-sqn] = lab[i]; cols_addrow(d, rc, d.rows[lab[i]], 1) } }
  n = 0
  for (i = THE.start + 1; (i in pool); i++) unlab[++n] = pool[i] }

function sort_by_disty(d, a, buf,    i, j, n, idx, t) {
  n = length(a)
  for (i = 1; i <= n; i++) buf[i] = disty(d, d.rows[a[i]])
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
    delete mb; delete mr
    mids(d, bc, mb)
    mids(d, rc, mr)
    pickk = pick_best(d, unlab, mb, mr)
    if (pickk == 0) break
    move_pick(d, unlab, pickk, lab, best, bc)
    cap_best(d, lab, best, rest, bc, rc) } }

function pick_best(d, unlab, mb, mr,   i, s, bestS, bestI, rid) {
  bestS = 1e30; bestI = 0
  for (i = 1; (i in unlab); i++) {
    rid = unlab[i]
    s = distx(d, d.rows[rid], mb) - distx(d, d.rows[rid], mr)
    if (s < bestS) { bestS = s; bestI = i } }
  return bestI }

function move_pick(d, unlab, ix, lab, best, bc,    rid, j) {
  rid = unlab[ix]
  for (j = ix; (j+1) in unlab; j++) unlab[j] = unlab[j+1]
  delete unlab[j]
  lab[length(lab)+1]   = rid
  best[length(best)+1] = rid
  cols_addrow(d, bc, d.rows[rid], 1) }

function cap_best(d, lab, best, rest, bc, rc,    cap, sortbuf, worst_id) {
  cap = int(sqrt(length(lab))); if (cap < 1) cap = 1
  while (length(best) > cap) {
    sort_by_disty(d, best, sortbuf)
    worst_id = best[length(best)]
    delete best[length(best)]
    cols_addrow(d, bc, d.rows[worst_id], -1)
    rest[length(rest)+1] = worst_id
    cols_addrow(d, rc, d.rows[worst_id], 1) } }

# ------------------------------------------------------------------ #
function rank_test_with(dt, d, t, test, ranked,    buf, i, j, n, idx, t1, t2) {
  n = length(test)
  for (i = 1; i <= n; i++) {
    buf[i] = Tree_walk(dt, t, d.rows[test[i]])
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
    dy = disty(dt, d.rows[ranked[i]])
    if (dy < best_d) { best_d = dy; best_id = ranked[i] } }
  return best_id }
