<a name=top>
<h2>
     The Gawk Object Layer
</h2>
<p>
   <a    href="http://menzies.us/awk/index">docs</a>
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
@include "some"

function okSome1(fun,  n,a,b,j,x) {
  for(n=1;n<=1.5;n+= 0.05) 
     _okSome(fun,n)
}
function okSome2(fun,  a,j) {
   Some(a)
   a.max = 32
   for(j=1;j<=10000; j++) add(a,j)
   Some_ok(a)
   ok(fun, length(a.all) < 35)
}
function _okSome(fun,n,   a,b,x,j,f) {
  Some(a)
  Some(b)
  for(j=1; j<=100; j++) {
     x = rand()
     add(a, x)
     add(b, x*n) }
  f= Some_same(a,b)
  ok(fun n "var",var(a) <= .35 && var(a) >=.25)
  ok(fun n DOT f,  n <=1.2 ? f==1 : f==0)
}
BEGIN { tests() }
```
