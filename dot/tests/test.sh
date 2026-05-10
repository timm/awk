#!/usr/bin/env bash
# tests/test.sh -- smoke tests for `dot`. Run from repo root: ./tests/test.sh
# Each test compares actual output against expected. Prints OK or FAIL+diff.

set -u
cd "$(dirname "$0")/.."
DOT=./dot

pass=0; fail=0
ok()   { printf "  \033[32mOK\033[0m   %s\n" "$1"; pass=$((pass+1)); }
bad()  { printf "  \033[31mFAIL\033[0m %s\n" "$1"; printf "       expected: %q\n       got:      %q\n" "$2" "$3"; fail=$((fail+1)); }
eq()   { local name="$1" expected="$2" got="$3"; [ "$expected" = "$got" ] && ok "$name" || bad "$name" "$expected" "$got"; }
contains() { local name="$1" needle="$2" hay="$3"; case "$hay" in *"$needle"*) ok "$name";; *) bad "$name" "...$needle..." "$hay";; esac; }

# run an inline awk program via dot. usage: run_inline 'BEGIN{...}' [DATA...]
run_inline() {
  local prog="$1"; shift
  local tmp; tmp=$(mktemp /tmp/dottest.XXXXXX).awk
  printf '%s\n' "$prog" > "$tmp"
  local out; out=$($DOT "$tmp" "$@" 2>&1)
  rm -f "$tmp"
  printf '%s' "$out"
}

echo "tests for $DOT"
echo

# --- build ---------------------------------------------------------
echo "build:"
out=$(./build.sh 2>&1)
contains "build.sh runs"           "built dot" "$out"
[ -x "$DOT" ]                       && ok "dot is executable" || bad "dot is executable" "x bit" "missing"

# --- help / no args ------------------------------------------------
echo
echo "help / discovery:"
contains "no args -> usage"        "Usage:" "$($DOT 2>&1)"
contains "--help has Usage"        "Usage:" "$($DOT --help)"
contains "--help lists --demo"     "--demo" "$($DOT --help)"
contains "--demos lists hello"     "hello" "$($DOT --demos)"

# --- preprocessor: -c ----------------------------------------------
echo
echo "preprocessor (-c):"
eq "field rewrite"                 'HEAP[it]["n"]++'             "$(echo '.it.n++' | $DOT -c /dev/stdin)"
eq "object rewrite"                'HEAP[d]'                     "$(echo '.d' | $DOT -c /dev/stdin)"
eq "nested rewrite"                'HEAP[d]["rows"][r][i]'       "$(echo '.d.rows[r][i]' | $DOT -c /dev/stdin)"
eq "explicit dot ok"               '"fred" "." "csv"'            "$(echo '"fred" "." "csv"' | $DOT -c /dev/stdin)"
eq "no dots = passthrough"         'NAME[i] = $i'                "$(echo 'NAME[i] = $i' | $DOT -c /dev/stdin)"

# --- demo runner ---------------------------------------------------
echo
echo "demo runner:"
eq "--demo hello (sample.txt)"     "n=5 mean=30.000"             "$($DOT --demo hello)"
eq "--demo hello (- means stdin)"  "n=3 mean=20.000"             "$(printf '10\n20\n30\n' | $DOT --demo hello -)"
eq "--demo hello (DATA arg)"       "n=2 mean=15.000"             "$($DOT --demo hello <(printf '10\n20\n'))"

# --- error handling ------------------------------------------------
echo
echo "errors:"
out=$($DOT --demo nonesuch 2>&1 || true)
contains "missing demo errors"     "no such demo" "$out"
out=$($DOT -c 2>&1 || true)
contains "-c needs file"           "need FILE.awk" "$out"

# --- runtime: new/arr/zap/.field via inline awk --------------------
echo
echo "runtime (new/arr/zap/.field):"
eq "new + .field"          "7 1.5" "$(run_inline 'BEGIN { N = new("plain"); .N.n = 7; .N.mu = 1.5; printf "%d %.1f\n", .N.n, .N.mu }')"
eq "zap drops slot"        "gone"  "$(run_inline 'BEGIN { N = new("x"); .N.n = 1; zap(N); printf "%s\n", ((N in HEAP) ? "kept" : "gone") }')"
eq "arr + nested key"      "2"     "$(run_inline 'BEGIN { N = new("y"); arr(.N.has); .N.has["a"] = 2; printf "%d\n", .N.has["a"] }')"

# --- printer (o, _oo) ----------------------------------------------
echo
echo "printer (o, _oo):"
eq "o(int)"                "5"           "$(run_inline 'BEGIN{o(5); print ""}')"
eq "o(5.0) collapses"      "5"           "$(run_inline 'BEGIN{o(5.0); print ""}')"
eq "o(5.123)"              "5.123"       "$(run_inline 'BEGIN{o(5.123); print ""}')"
eq "o(string)"             "hi"          "$(run_inline 'BEGIN{o("hi"); print ""}')"
eq "o(list)"               "[1, 2, 3]"   "$(run_inline 'BEGIN{a[1]=1;a[2]=2;a[3]=3; o(a); print ""}')"
eq "o(dict sorted)"        "{a: 1, b: 2}" "$(run_inline 'BEGIN{b["b"]=2; b["a"]=1; o(b); print ""}')"
eq "o(list numeric sort)"  "[3, 2, 1]"   "$(run_inline 'BEGIN{a[10]=1;a[2]=2;a[1]=3; o(a); print ""}')"

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
