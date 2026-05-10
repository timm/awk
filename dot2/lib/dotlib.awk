# dotlib.awk -- generic helpers (no object knowledge).
# rogues(): leak check.   o(x): polymorphic print.   _oo: workhorse.

# rogues(): warn on lowercase globals at end of run. Discipline check.
function rogues(    i) {
  for (i in SYMTAB) if (i ~ /^[a-z]/) print "leak:", i > "/dev/stderr" }

# o(x): print one thing.
#   array, 1 in x   -> "[..]" list,  numeric-sorted, no key prefix
#   array, no 1     -> "{..}" dict,  string-sorted,  "k: " prefix
#   number-shaped   -> %d if whole, else %G
#   else            -> %s
function o(x) {
  if (isarray(x)) {
    if (1 in x) _oo(x, "[", "]", "@ind_num_asc", 0)
    else        _oo(x, "{", "}", "@ind_str_asc", 1)
  } else if (x ~ /^-?[0-9]+(\.[0-9]+)?([eE][-+]?[0-9]+)?$/) {
    if (x == int(x)) printf "%d", x
    else             printf "%G", x }
  else printf "%s", x }

function _oo(a, lhs, rhs, how, withkey,    n, i, k, sep, sorted) {
  printf "%s", lhs
  n = asorti(a, sorted, how)
  sep = ""
  for (i = 1; i <= n; i++) {
    k = sorted[i]
    printf "%s", sep
    if (withkey) printf "%s: ", k
    o(a[k])
    sep = ", " }
  printf "%s", rhs }
