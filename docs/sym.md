<a name=top>
<img align=right width=150 src="https://github.com/timm/awk/blob/master/etc/img/greatauk.jpg">
<h2>
     The Gawk Object Layer
</h2>
<p>
   <a    href="http://menzies.us/awk/index">docs</a>
   :: <a href="http://github.com/timm/awk">code</a>
   :: <a href="http://menzies.us/awk/index#map">map</a>
   :: <a href="http://menzies.us/awk/index#license">license</a>
   :: <a href="http://menzies.us/awk/index#install">install</a><br>
   <a href="http://menzies.us/awk/index#contribute">contrib</a>
   :: <a href="http://github.com/timm/awk/issues">issues</a>
   :: <a href="http://menzies.us/awk/index#cite">cite</a>
   :: <a href="http://menzies.us/awk/index#contact">contact</a>
<br>
   <img src="https://img.shields.io/badge/language-gawk-orange">
   <img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
   <img src="https://img.shields.io/badge/platform-mac,*nux-informational">
</p>

# Symbolic columns

```awk
@include "some"

function Sym(i) {
  isa(i,"Sym")
  has(i,"seen")
  i.mode=""
  i.most=0
}
function _var(i) { return _ent(i) }
function _mid(i) { return i.mode }

function _add1(i,x,     n) {
  if ("some" in i) add(i.some,x)
  n = i.seen[x]+1
  if (n > i.most) {i.most=n; i.mode=x}
  i.seen[x] = n
}

function _ent(i,      j,e,n) {
  for(j in i.seen) {
    n = i.seen[j]
    if (n>0) 
      e -= (n/i.n)*log(n/i.n)/log(2)};
  return e
}
```
