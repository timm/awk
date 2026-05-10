#!/usr/bin/env bash
# tests/test.sh -- smoke tests for `dot2cols`.

set -u
cd "$(dirname "$0")/.."
DC=./dot2cols

pass=0; fail=0
ok()   { printf "  \033[32mOK\033[0m   %s\n" "$1"; pass=$((pass+1)); }
bad()  { printf "  \033[31mFAIL\033[0m %s\n" "$1"; printf "       expected: %q\n       got:      %q\n" "$2" "$3"; fail=$((fail+1)); }
eq()   { local name="$1" expected="$2" got="$3"; [ "$expected" = "$got" ] && ok "$name" || bad "$name" "$expected" "$got"; }
contains() { local name="$1" needle="$2" hay="$3"; case "$hay" in *"$needle"*) ok "$name";; *) bad "$name" "...$needle..." "$hay";; esac; }

run_inline() {
  local prog="$1"; shift
  local tmp; tmp=$(mktemp /tmp/dc2test.XXXXXX).awk
  printf '%s\n' "$prog" > "$tmp"
  local out; out=$($DC "$tmp" "$@" 2>&1)
  rm -f "$tmp"
  printf '%s' "$out"
}

echo "tests for $DC"
echo

echo "build:"
out=$(./build.sh 2>&1)
contains "build.sh runs"       "built dot2cols" "$out"
[ -x "$DC" ] && ok "dot2cols is executable" || bad "dot2cols is executable" "x bit" "missing"

echo
echo "help / discovery:"
contains "no args -> usage"        "Usage:"  "$($DC 2>&1)"
contains "--help has --demo"       "--demo"  "$($DC --help)"
contains "--demos lists stats"     "stats"   "$($DC --demos)"

echo
echo "inherits dot2:"
eq "new + field still works"   "7"  "$(run_inline 'BEGIN { new(N,"plain"); N.n = 7; printf "%d\n", N.n }')"
eq "o(5.0) still collapses"    "5"  "$(run_inline 'BEGIN { o(5.0); print "" }')"

echo
echo "Num type:"
eq "Num via add()"  "30 15.811" "$(run_inline 'BEGIN { Num(N); add(N,10,1); add(N,20,1); add(N,30,1); add(N,40,1); add(N,50,1); printf "%d %.3f\n", mid(N), var(N) }')"
eq "Num mid"        "30"        "$(run_inline 'BEGIN { Num(N); for (i=1;i<=5;i++) add(N,i*10,1); printf "%d\n", mid(N) }')"
eq "mk(Num)"        "Num"       "$(run_inline 'BEGIN { mk(N,"Num"); printf "%s\n", N.is }')"

echo
echo "Sym type:"
eq "Sym mode"       "b"         "$(run_inline 'BEGIN { Sym(S); add(S,"a",1); add(S,"b",1); add(S,"b",1); printf "%s\n", mid(S) }')"
eq "Sym entropy>0"  "yes"       "$(run_inline 'BEGIN { Sym(S); add(S,"a",1); add(S,"b",1); printf "%s\n", (var(S) > 0 ? "yes" : "no") }')"

echo
echo "Data type:"
eq "data ingests rows" "303" "$(run_inline '
BEGIN { Data(d); FS = " *, *" }
NR==1 { Data_head(d, $0); next }
      { Data_read(d, 1) }
END   { printf "%d\n", d.nrows }
' demos/stats/sample.csv)"

echo
echo "demo runner:"
out=$($DC --demo stats)
contains "stats demo header"   "column"     "$out"
contains "stats demo body"     "AGE"        "$out"
contains "stats demo bottom"   "num!"       "$out"

echo
echo "errors:"
out=$($DC --demo nonesuch 2>&1 || true)
contains "missing demo errors" "no such demo" "$out"

echo
total=$((pass+fail))
if [ $fail -eq 0 ]; then
  printf "\n\033[32mAll %d tests passed.\033[0m\n" "$total"
  exit 0
else
  printf "\n\033[31m%d/%d failed.\033[0m\n" "$fail" "$total"
  exit 1
fi
