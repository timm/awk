# dist.awk -- Minkowski distance functions on numeric/symbolic columns.
# requires: dot.awk, numsym.awk, data.awk

# distance to heaven across y-columns. .d.y[i] = 1 (max) or 0 (min).
function disty(d, row,    i, c, n, s) {
  for (i in .d.y) {
    n++
    c = .d.cols[i]
    s += (num_norm(c, row[i]) - .d.y[i]) ^ THE.p }
  return (s / n) ^ (1 / THE.p) }

# distance between two values on one column.
function aha(c, u, v,    nu, nv) {
  if (u == "?" && v == "?") return 1
  if (.c.is == "sym") return u != v
  nu = num_norm(c, u)
  nv = num_norm(c, v)
  if (u == "?") nu = (nv > 0.5 ? 0 : 1)
  if (v == "?") nv = (nu > 0.5 ? 0 : 1)
  return (nu > nv ? nu - nv : nv - nu) }

# distance between two rows on x-columns.
function distx(d, r1, r2,    i, c, n, s) {
  for (i = 1; i <= .d.nc; i++) {
    if (i in .d.y || i == .d.klass) continue
    n++
    s += aha(.d.cols[i], r1[i], r2[i]) ^ THE.p }
  return (s / n) ^ (1 / THE.p) }

# centroid: write each col's mid into row[i].
function mids(d, cols, row,    i) {
  for (i = 1; i <= .d.nc; i++) row[i] = mid(cols[i]) }
