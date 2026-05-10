# wins.awk -- percentile-based scorer (0..100, higher = better).
# usage:
#   Wins(W, d, rows)              # rows = array of indices into d.rows
#   s = Wins_score(d, row, W)     # row  = an actual row (d.rows[i])

function Wins(w, d, rows,    tmp, i, n, ten) {
  new(w, "Wins")
  for (i in rows) tmp[++n] = disty(d, d.rows[rows[i]])
  if (n < 2) return
  isort(tmp, n)
  ten = int(n / 10); if (ten < 1) ten = 1
  w.lo  = tmp[1]
  w.med = tmp[int((n + 1) / 2)]
  w.sd  = (tmp[n - ten + 1] - tmp[ten]) / 2.56 }

function Wins_score(d, row, w,    x, num) {
  x = disty(d, row)
  if (x < w.lo + 0.35 * w.sd) x = w.lo
  num = 100 * (1 - (x - w.lo) / (w.med - w.lo + 1e-32))
  if (num < -100) num = -100
  return int(num) }

# in-place insertion sort (small n only).
function isort(a, n,    i, j, key) {
  for (i = 2; i <= n; i++) {
    key = a[i]; j = i - 1
    while (j >= 1 && a[j] > key) { a[j+1] = a[j]; j-- }
    a[j+1] = key } }
