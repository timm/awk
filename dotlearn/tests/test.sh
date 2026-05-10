#!/usr/bin/env bash
# tests/test.sh -- smoke tests for `dotlearn`. Run from repo root: ./tests/test.sh

set -u
cd "$(dirname "$0")/.."
DL=./dotlearn

pass=0; fail=0
ok()   { printf "  \033[32mOK\033[0m   %s\n" "$1"; pass=$((pass+1)); }
bad()  { printf "  \033[31mFAIL\033[0m %s\n" "$1"; printf "       expected: %q\n       got:      %q\n" "$2" "$3"; fail=$((fail+1)); }
eq()   { local name="$1" expected="$2" got="$3"; [ "$expected" = "$got" ] && ok "$name" || bad "$name" "$expected" "$got"; }
contains() { local name="$1" needle="$2" hay="$3"; case "$hay" in *"$needle"*) ok "$name";; *) bad "$name" "...$needle..." "$hay";; esac; }
nonempty() { local name="$1" hay="$2"; [ -n "$hay" ] && ok "$name" || bad "$name" "non-empty" "(empty)"; }

run_inline() {
  local prog="$1"; shift
  local tmp; tmp=$(mktemp /tmp/dltest.XXXXXX).awk
  printf '%s\n' "$prog" > "$tmp"
  local out; out=$($DL "$tmp" "$@" 2>&1)
  rm -f "$tmp"
  printf '%s' "$out"
}

echo "tests for $DL"
echo

# --- build ---------------------------------------------------------
echo "build:"
out=$(./build.sh 2>&1)
contains "build.sh runs"     "built dotlearn" "$out"
[ -x "$DL" ] && ok "dotlearn is executable" || bad "dotlearn is executable" "x bit" "missing"

# --- help / discovery ----------------------------------------------
echo
echo "help / discovery:"
contains "no args -> usage"     "Usage:"     "$($DL 2>&1)"
contains "--help has --demo"    "--demo"     "$($DL --help)"
contains "--demos lists tree"   "tree"       "$($DL --demos)"
contains "--demos lists nb"     "nb"         "$($DL --demos)"
contains "--demos lists acquire" "acquire"   "$($DL --demos)"

# --- inherits dot + dotcols ----------------------------------------
echo
echo "inherits dot + dotcols:"
eq "new + .field"   "7"   "$(run_inline 'BEGIN { N = new("plain"); .N.n = 7; printf "%d\n", .N.n }')"
eq "Num via add()"  "30"  "$(run_inline 'BEGIN { N = new("num"); for (i=1;i<=5;i++) add(N,i*10,1); printf "%d\n", mid(N) }')"
eq "Data ingests"   "303" "$(run_inline '
BEGIN { d = new("data"); FS = " *, *" }
NR==1 { data_head(d, $0); next }
      { data_read(d, 1) }
END   { printf "%d\n", .d.nrows }
' demos/tree/sample.csv)"

# --- distance (dist.awk) -------------------------------------------
echo
echo "distance (dist.awk):"
out=$(run_inline '
BEGIN { d = new("data"); FS = " *, *" }
NR==1 { data_head(d, $0); next }
      { data_read(d, 1) }
END   { print disty(d, .d.rows[1]) }
' demos/tree/sample.csv)
nonempty "disty(row 1)" "$out"

# --- demo: tree -----------------------------------------------------
echo
echo "demo: tree (heart.c.csv):"
out=$($DL --demo tree)
nonempty   "tree produces output"  "$out"
contains   "tree output is pred,actual"  "<50" "$out"
n=$(printf '%s\n' "$out" | wc -l | tr -d ' ')
[ "$n" -gt 50 ] && ok "tree output >50 rows" || bad "tree output >50 rows" ">50" "$n"

# --- demo: nb -------------------------------------------------------
echo
echo "demo: nb (heart.c.csv):"
out=$($DL --demo nb)
nonempty "nb produces output"      "$out"
contains "nb output is pred,actual" "," "$out"

# --- demo: acquire --------------------------------------------------
echo
echo "demo: acquire (auto93.csv):"
out=$($DL --demo acquire 2>&1)
contains "acquire prints RESULT block" "RESULT"   "$out"
contains "acquire reports labelled"    "labelled" "$out"

# --- error handling ------------------------------------------------
echo
echo "errors:"
out=$($DL --demo nonesuch 2>&1 || true)
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
