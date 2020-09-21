<a name=top>
<h2>
     GOLD = the Gawk Object Layer
</h2>
<p>
   <a    href="https://github.com/timm/awk/blob/masterREADME.md#license">license</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#install">install</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#contribute">contribute</a>
   :: <a href="https://github.com/timm/awk/issues">issues</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#citation">cite</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#contatct">contact</a>
</p>
<p>
   <img src="https://img.shields.io/badge/language-gawk-orange">
   <img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
   <img src="https://img.shields.io/badge/platform-mac,*nux-informational">
</p>

```awk
function add1(i,x, f) { f=i.isa "_add1"; return @f(i,x) }
function loop(i,   f) { f=i.isa "_loop"; return @f(i) }
function var(i,    f) { f=i.isa "_var";  return @f(i) }
function mid(i,    f) { f=i.isa "_mid";  return @f(i) }
```
