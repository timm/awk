# numsym.awk -- NUM and SYM types + their polymorphic dispatch
# polymorphic ops:  add, like, var, mid     (also: num_norm)
# coercion happens inside *_add; here we only guard "?"

# --- dispatch (lives with num/sym, the types it switches over) -----
function add (k, x, train, w,  fn) { fn = .k.is "_add"
                                     return @fn(k, x, train, w) }
function like(k, x, p, m,   fn) { fn = .k.is "_like"
                                  return @fn(k, x, p, m) }
function var(it,    fn) { fn = .it.is "_var"; return @fn(it) }
function mid(it,    fn) { fn = .it.is "_mid"; return @fn(it) }

# --- NUM ------------------------------------------------------------
# w is optional weight (default 1). w=-1 subtracts.
function num_add(it, x, train, w,    d, d2) {
  w = (w == "" ? 1 : w + 0)
  if (x == "?") return x
  x += 0
  if (!train) return x
  if (w < 0 && .it.n <= 2) { .it.n=0; .it.mu=0; .it.m2=0; return x }
  .it.n  += w
  d  = x - .it.mu;  .it.mu += w * d / .it.n
  d2 = x - .it.mu;  .it.m2 += w * d * d2
  return x }

function num_var(it) {
  return .it.n < 2 ? 0 : sqrt(.it.m2 / (.it.n - 1)) }

function num_mid(it) { return .it.mu }

function num_norm(it, x,    s, z) {
  if (x == "?") return 0.5
  s = num_var(it) + 1e-30
  z = (x - .it.mu) / s
  if (z < -3) z = -3; else if (z > 3) z = 3
  return 1 / (1 + exp(-1.7 * z)) }

function num_like(it, x, prior, m,    s, z) {
  if (x == "?") return 1
  s = num_var(it) + 1e-30;  z = (x - .it.mu) / s
  return exp(-z*z/2) / (s * 2.5066282746) }

# --- SYM ------------------------------------------------------------
function sym_init(it)   { arr(.it.has); return it }

function sym_add(it, x, train, w) {
  w = (w == "" ? 1 : w + 0)
  if (x == "?" || !train) return x
  .it.n      += w
  .it.has[x] += w
  if (.it.has[x] <= 0) delete .it.has[x]
  return x }

function sym_var(it,    e, k, p) {
  for (k in .it.has) { p = .it.has[k]/.it.n; e -= p*log(p) }
  return e }

function sym_mid(it,    k, b, bv) {
  bv = -1
  for (k in .it.has) if (.it.has[k] > bv) { bv = .it.has[k]; b = k }
  return b }

function sym_like(it, x, prior, m,    f) {
  if (x == "?") return 1
  f = (x in .it.has) ? .it.has[x] : 0
  return (f + m*prior) / (.it.n + m) }
