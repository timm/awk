```awk
@include "gold"

function Xy(i) { isa(i,"Xy");has(i,"all") has(i,"nums");has(i,"syms") }
function _add(i, num,n) {i.all[n]; num  ? i.nums[n] : i.syms[n] }
 
function Meta(i) {
  isa(i,"Meta")
  has(i,"all") }
  has(i,"x","Xy"); has(i,"y","Xy");  has(i,"xy","Xy") 
}
function _add(i,a, n,is)
  for(n in a) {
    is.num  = a[n] ~ /:<>/
    is.xy   = a[n] ~ /!<>/ ? "y" : "x"
    is.less = a[n] ~ /</   ? -1  : 1
    has(i.all, n, is.num ? "Num" : "Sym")
    i.all[n].txt = a[n]
    i.all[n].pos = n
    i.all[n].w   = is.less
    add(i.xy,     is.num, n) 
    add(i[is.xy], is.num, n) 
}
function keep(i) {
  if (length(Some[i]) < 
}
NR==1 { header() }
NR> 1 { for(i in Use[i]) D[NR-1][i] = $Use[i] }
CODE
  has(i,"cells")
  has(i,"cooked")
}
```
