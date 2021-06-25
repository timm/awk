# vim:  ts=2 sw=2 et :
BEGIN {FS=","}

function o(a,   i,sep) {
  for(i in a) {printf("%s:%s %s",sep,i,a[i]); sep=", "}}

function have(z) { split("",z,"")}
function tab(Tab) { 
    have(txt); have(xs); have(ys); have(all); have(w);
    have(lo);have(hi); have(rows) }

function read(f, Tab,   x,a) {
  f=f ? f : "-"
  tab(Tab)
  while((getline x < f) > 0) {split(x,a,",");add(a,Tab)} }

function add(a,Tab) { 
  length(txt) ? data(a,Tab) : header(a,Tab) }

function data(a,Tab,   r,c) {
  r = length(rows)+1
  for(c in a) {
    rows[r][c] = z = a[c]
    if (z != "?") {
      if(c in hi)  {
        if (z > hi[c]) hi[c]=x
        if (z < lo[c]) lo[c]=x }}}}

function header(a,Tab) {
  for(c in a) {
    txt[c] = z = a[c]
    if (z !~ /\?/) {
      w[c] = z ~ /-/ ? -1   : 1 
      z ~ /[\+\-!]/ ? ys[c] : xs[c]
      if (z ~ /^[A-Z]/) { lo[c] = 10^32; hi[c] = -10^32 } }}}
   
BEGIN {read("data/auto93.csv")}
