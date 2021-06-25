# vim:  ts=2 sw=2 et :
BEGIN {FS=","}

function read(f, header,xs,ys,all,w,lo,hi,rows,   x,a) {
  f=f ? f : "-"
  while((getline x < f) > 0) {split(x,a,",");row(a,header,xs,ys,all,w,lo,hi,rows)}
}
function row(a,header,xs,ys,all,w,lo,hi,rows) { print a[1] }

BEGIN {read("data/auto93.csv")}
