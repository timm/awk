#!/usr/bin/env bash
# tests/test.sh -- smoke tests for `dotcols`. Run from repo root: ./tests/test.sh

set -u
cd "$(dirname "$0")/.."
DC=./dotcols

pass=0; fail=0
ok()   { printf "  \033[32mOK\033[0m   %s\n" "$1"; pass=$((pass+1)); }
bad()  { printf "  \033[31mFAIL\033[0m %s\n" "$1"; printf "       expected: %q\n       got:      %q\n" "$2" "$3"; fail=$((fail+1)); }
eq()   { local name="$1" expected="$2" got="$3"; [ "$expected" = "$got" ] && ok "$name" || bad "$name" "$expected" "$got"; }
contains() { local name="$1" needle="$2" hay="$3"; case "$hay" in *"$needle"*) ok "$name";; *) bad "$name" "...$needle..." "$hay";; esac; }

run_inline() {
  local prog="$1"; shift
  local tmp; tmp=$(mktemp /tmp/dctest.XXXXXX).awk
  printf '%s\n' "$prog" > "$tmp"
  local out; out=$($DC "$tmp" "$@" 2>&1)
  rm -f "$tmp"
  printf '%s' "$out"
}

echo "tests for $DC"
echo

# --- build ---------------------------------------------------------
echo "build:"
out=$(./build.sh 2>&1)
contains "build.sh runs"    "built dotcols" "$out"
[ -x "$DC" ] && ok "dotcols is executable" || bad "dotcols is executable" "x bit" "missing"

# --- help / discovery ----------------------------------------------
echo
echo "help / discovery:"
contains "no args -> usage"   "Usage:"     "$($DC 2>&1)"
contains "--help has --demo"  "--demo"     "$($DC --help)"
contains "--help has --get-data" "--get-data" "$($DC --help)"
contains "--demos lists stats" "stats"     "$($DC --demos)"

# --- inherits dot's runtime ----------------------------------------
echo
echo "inherits dot runtime:"
eq "new + .field still works"   "7"  "$(run_inline 'BEGIN { N = new("plain"); .N.n = 7; printf "%d\n", .N.n }')"
eq "o(5.0) still collapses"     "5"  "$(run_inline 'BEGIN { o(5.0); print "" }')"

# --- Num type ------------------------------------------------------
echo
echo "Num type (numsym.awk):"
eq "num via add()" "30 15.811" "$(run_inline 'BEGIN { N = new("num"); add(N,10,1); add(N,20,1); add(N,30,1); add(N,40,1); add(N,50,1); printf "%d %.3f\n", mid(N), var(N) }')"
eq "num mid alias" "30"        "$(run_inline 'BEGIN { N = new("num"); for (i=1;i<=5;i++) add(N,i*10,1); printf "%d\n", mid(N) }')"

# --- Sym type ------------------------------------------------------
echo
echo "Sym type:"
eq "sym mode"      "b"         "$(run_inline 'BEGIN { S = new("sym"); add(S,"a",1); add(S,"b",1); add(S,"b",1); printf "%s\n", mid(S) }')"
eq "sym entropy>0" "yes"       "$(run_inline 'BEGIN { S = new("sym"); add(S,"a",1); add(S,"b",1); printf "%s\n", (var(S) > 0 ? "yes" : "no") }')"

# --- Data type -----------------------------------------------------
echo
echo "Data type (data.awk):"
eq "data ingests rows" "303" "$(run_inline '
BEGIN { d = new("data"); FS = " *, *" }
NR==1 { data_head(d, $0); next }
      { data_read(d, 1) }
END   { printf "%d\n", .d.nrows }
' demos/stats/sample.csv)"

# --- demo runner ---------------------------------------------------
echo
echo "demo runner:"
out=$($DC --demo stats)
contains "stats demo header"   "column"     "$out"
contains "stats demo body"     "AGE"        "$out"
contains "stats demo bottom"   "num!"       "$out"

# --- error handling ------------------------------------------------
echo
echo "errors:"
out=$($DC --demo nonesuch 2>&1 || true)
contains "missing demo errors" "no such demo" "$out"

# --- summary -------------------------------------------------------
echo
total=$((pass+fail))
if [ $fail -eq 0 ]; then
  printf "\n\033[32mAll %d tests passed.\033[0m\n" "$total"
  exit 0
else
  printf "\n\033[31m%d/%d failed.\033[0m\n" "$fail" "$total"
  exit 1
fi
