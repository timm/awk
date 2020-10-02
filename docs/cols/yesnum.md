<a name=top>
<img align=right width=200 src="https://raw.githubusercontent.com/timm/awk/master/etc/img/miner.png" width=200>
<h2>
     GOLD = The Gawk Object Layer
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
@include "lib/list"
@include "cols/num"
@include "cols/col"

function okNum(fun,  x,j) {
  Num(x)
  somed(x)
  for(j=1;j<=10000;j++) add(x, norm(314,2.7135))
  ok(fun 1, abs(mid(x)-mid(x.some)) < 0.5)
  ok(fun 2, abs(var(x) - var(x.some))/ var(x.some) <0.05)
}
BEGIN {tests()}
```
