<a name=top>
<img align=right src="https://raw.githubusercontent.com/timm/awk/master/etc/img/spiny.png" width=200>
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
BEGIN {
  THE.some.max    = 256
  THE.some.few    =  64

  THE.stats.cliff =  .147

  THE.ch.skip     = "?"
  THE.ch.less     = "<"
  THE.ch.more     = ">"
  THE.ch.num      = ":"
  THE.ch.klass    = "!"
}

function data(f) { return DOT DOT "/data/" f DOT "csv" }
```

Polymorphic verbs:
     
```awk
function add1(i,x, f) { f=i.isa "_add1"; return @f(i,x) }
function loop(i,   f) { f=i.isa "_loop"; return @f(i) }
function var(i,    f) { f=i.isa "_var";  return @f(i) }
function mid(i,    f) { f=i.isa "_mid";  return @f(i) }
```
```
