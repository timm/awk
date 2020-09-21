<a name=top>
<h1 align=center>
     GOLD = the Gawk Object Layer
</h1>
<p align=center>
   <a    href="https://github.com/timm/awk/blob/masterREADME.md#license">license</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#install">install</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#contribute">contribute</a>
   :: <a href="https://github.com/timm/awk/issues">issues</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#citation">cite</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#contatct">contact</a>
</p>
<p align=center>
   <img src="https://img.shields.io/badge/language-gawk-orange">
   <img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
   <img src="https://img.shields.io/badge/platform-mac,*nux-informational">
</p>

```awk
@include "the"
@include "poly"
@include "num"

function adds(a,out,fun,    j) {
  fun = fun?fun:"Num"
  @fun(out)
  for(j in a) add(out, a[j])
}

function add(i,x) {
  if (x != THE.ch.skip)  { i.n++; add1(i,x) }
  return x
}
```
