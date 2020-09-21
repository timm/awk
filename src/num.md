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
