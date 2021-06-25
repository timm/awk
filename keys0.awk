# vim:  ts=2 sw=2 et :
BEGIN {FS=","}

function read(f, Tab,   x,a) {
  f=f ? f : "-"
  while((getline x < f) > 0) {split(x,a,",");tab(a,Tab)} }

function tab(a,Tab) { 
  length(header) ? data(a,Tab) : header(a,Tab) }

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
    z = header[c] = a[c]
    if (z !~ /\?/) {
      w[c] = z ~ /-/ ? -1   : 1 
      z ~ /[\+\-\!]/ ? y[c] : x[c]
      if (z ~ /^[A-Z]/) { lo[c] = 10^32; hi[c] = -10^32 } }}}
   
BEGIN {read("data/auto93.csv")}
