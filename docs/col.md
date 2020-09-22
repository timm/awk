<a name=top>
<h2>
     The Gawk Object Layer
</h2>
<p>
   <a    href="http://menzies.us/awk/index">docs</a>
   :: <a href="http://menzies.us/awk/index#license">license</a>
   :: <a href="http://menzies.us/awk/index#install">install</a>
   :: <a href="http://menzies.us/awk/index#contribute">contribute</a>
   :: <a href="http://github.com/timm/awk/issues">issues</a>
   :: <a href="http://menzies.us/awk/index#cite">cite</a>
   :: <a href="http://menzies.us/awk/index#contact">contact</a>
<br>
   <img src="https://img.shields.io/badge/language-gawk-orange">
   <img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
   <img src="https://img.shields.io/badge/platform-mac,*nux-informational">
</p>

```awk
@include "the"
@include "poly"
@include "num"
@include "some"

function adds(a,out,fun,    j) {
  fun = fun?fun:"Num"
  @fun(out)
  for(j in a) add(out, a[j])
}

function add(i,x) {
  if (x != THE.ch.skip)  { i.n++; add1(i,x) }
  return x
}
function somed(i) {
  has(i,"some","Some")
}
```
