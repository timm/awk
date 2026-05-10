# prep:  .f after value-char  ->  ["f"]      (field access)
#        .x bare              ->  HEAP[x]    (object reference)
# Note: uses match()/substr() loop instead of gensub(...,"g")
#       to dodge a gawk 5.4.0 bug where 2nd match's captures go empty.
{ s = $0
  while (match(s, /([A-Za-z0-9_\]\)])\.([A-Za-z_][A-Za-z_0-9]*)/, m))
    s = substr(s,1,RSTART-1) m[1] "[\"" m[2] "\"]" substr(s,RSTART+RLENGTH)
  while (match(s, /\.([A-Za-z_][A-Za-z_0-9]*)/, m))
    s = substr(s,1,RSTART-1) "HEAP[" m[1] "]" substr(s,RSTART+RLENGTH)
  print s }
