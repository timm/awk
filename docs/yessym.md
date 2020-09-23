<a name=top>
<img align=right src="https://raw.githubusercontent.com/timm/awk/master/etc/img/greatauk.jpg" width=200>
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

```awk
@include "gold"
@include "list"
@include "sym"
@include "col"

function okSym(fun,  x,a,j) {
  Sym(x)
  split("aaaabbc",a,"")
  for(j in a) add(x, a[j])
  ok(fun, abs(1.378 - var(x)) < 0.01)
}
BEGIN {tests()}
```
