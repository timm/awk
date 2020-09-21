<a name=top>
<h1 align=center>
   <a href="https://github.com/timm/awk/blob/master/README.md#top">
     GOLD = the Gawk Object Layer
   </a>
</h1>
<p align=center>
   <a    href="https://github.com/timm/awk/blob/masterREADME.md#license">license</a>
   :: <a href="https://github.com/timm/awk/blob/master/INSTALL.md#install">install</a>
   :: <a href="https://github.com/timm/awk/blob/master/CONTRIBUTE.md#contribute">contribute</a>
   :: <a href="https://github.com/timm/awk/issues">issues</a>
   :: <a href="https://github.com/timm/awk/blob/master/CITATION.md#citation">cite</a>
   :: <a href="https://github.com/timm/awk/blob/master/CONTACT.md#contatct">contact</a>
</p>
<p align=center>
   <img width=450 src="https://github.com/timm/awk/raw/master/etc/img/coins.png">
</p>
<p align=center>
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
