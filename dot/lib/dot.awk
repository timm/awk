# dot.awk -- the entire object runtime. Three functions.
# The preprocessor turns .it.foo into HEAP[it]["foo"] before this file is read.

# new(t): allocate a fresh object id, tag it, run optional t_init().
function new(t,    it, fn) {
  it = ++NID;  .it.is = t
  fn = t "_init"
  return (fn in FUNCTAB) ? @fn(it) : it }

# arr(x): force x to be an array. Safe to "for k in x" when later empty.
function arr(x) { x[""] = 0; delete x[""] }

# zap(i): clear one HEAP slot. Use when caller is done with object i.
function zap(i) { delete HEAP[i] }
