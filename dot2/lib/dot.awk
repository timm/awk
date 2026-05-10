# dot.awk -- heap-free object runtime + preprocessor (one file).
#
# As preprocessor:  gawk -v PREP=1 -f dot.awk SRC.awk > OUT.awk
# As runtime lib:   gawk -f dot.awk -f MYAPP.awk DATA
#
# Preprocessor rule: ".f" after a value-char becomes ["f"].
# So  it.foo        ->  it["foo"]
#     d.cols[i].is  ->  d["cols"][i]["is"]
# Heap-free: objects are arrays passed by reference; users write
# "it.foo", not ".it.foo".

# --- preprocessor pattern (fires only when -v PREP=1) --------------
# Note: uses match()/substr() loop to dodge a gawk 5.4.0 captures bug.
PREP == 1 {
  S = $0
  while (match(S, /([A-Za-z0-9_\]\)])\.([A-Za-z_][A-Za-z_0-9]*)/, M))
    S = substr(S,1,RSTART-1) M[1] "[\"" M[2] "\"]" substr(S,RSTART+RLENGTH)
  print S
  next }

# --- runtime: three functions --------------------------------------

# new(i, t): wipe i to empty array, tag i["is"]=t. First line of every
# constructor.
function new(i, t) { split("", i, ""); i["is"] = t }

# mk(i, t): polymorphic create. If t is a defined function, call it on i;
# else just new(i, t). Use for "give me a fresh Num/Sym/Data" by name.
function mk(i, t) {
  if (t in FUNCTAB) @t(i)
  else              new(i, t) }

# arr(x): force x to be an empty array.
function arr(x) { split("", x, "") }
