# numeric columns

```awk
@include "some"

function Num(i) {
  isa(i,"Num")
  i.hi=-10**32
  i.lo=10**32
  has(i,"some","Some")
}
function _var(i) { return Some_var(i.some) }
function _mid(i) { return Some_mid(i.some) }

function _add1(i, x) {
  add(i.some,x)
  i.hi = max(i.hi,x)
  i.lo = min(i.lo,x)
}
```
