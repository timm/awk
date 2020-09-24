<a name=top>
<img align=right src="https://raw.githubusercontent.com/timm/awk/master/etc/img/parts.png" width=200>
<h2>
     The Gawk Object Layer
</h2>
<p>
   <a    href="http://menzies.us/awk/index">docs</a>
   :: <a href="http://github.com/timm/awk">code</a>
   :: <a href="http://menzies.us/awk/index#map">map</a>
   :: <a href="http://menzies.us/awk/index#license">license</a>
   :: <a href="http://menzies.us/awk/index#install">install</a>
   :: <a href="http://menzies.us/awk/index#contribute">contrib</a>
   :: <a href="http://github.com/timm/awk/issues">issues</a>
   :: <a href="http://menzies.us/awk/index#cite">cite</a>
   :: <a href="http://menzies.us/awk/index#contact">contact</a>
<br>
   <img src="https://img.shields.io/badge/language-gawk-orange">
   <img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
   <img src="https://img.shields.io/badge/platform-mac,*nux-informational">
</p>

# numeric columns

```awk
@include "some"

function Num(i) {
  isa(i,"Num")
  i.hi=-10**32
  i.lo=10**32
  i.n=i.sd=i.mu=i.m2=0
}
function _var(i) { return i.sd }
function _mid(i) { return i.mu }

function _add1(i, x,     d) {
  if ("some" in i) add(i.some,x)
  i.hi  = max(i.hi,x)
  i.lo  = min(i.lo,x)
  d     = x - i.mu
  i.mu += d / i.n
  i.m2 += d * (x - i.mu) 
  if (i.n  < 2) i.sd=0  
  else i.sd = (i.m2 <= 0)?0:(i.m2/(i.n-1))^0.5 
}
```
