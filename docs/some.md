<a name=top>
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

# Some

Reservoir Sampling

```awk
@include "the"
@include "list"
@include "col"
@include "math"

function Some(i, max) {
  isa(i,"Some")
  i.n = 0
  i.ok = 1          
  i.max = max ? max : THE.some.max
  has(i,"all")
}
function _add1(i,x) {
  if (length(i.all)  < i.max) 
    _update(i, x, length(i.all) + 1)
  else if (rand() < i.max/i.n) 
    _update(i, x, int(0.5+length(i.all)*rand()))
}
function _update(i,x,k) { i.all[k]=x; i.ok=0 }

function _ok(i)  { 
  if (!i.ok) i.ok= asort(i.all) }

function _var(i,  lo,hi) { return ( _per(i,.9) - _per(i, .1))/2.6 }
```
Must  update this with https://bmcmedresmethodol.biomedcentral.com/articles/10.1186/1471-2288-14-135
go with S2 (outliers)

```awk
function _mid(i,  lo,hi) { return _per(i,.5,lo,hi) }

function _per(i,p , lo,hi) {
  p  = p?p: 0.5
  lo = lo?lo: 1
  hi = hi?hi: length(i.all)
  _ok(i)
  return i.all[ int(0.5 + lo+p*(hi-lo)) ]
}
function _few(i,few,   j,k) {
  _ok(i)
  List(few)
  k = max(1, int(0.5+ length(i.all)/ THE.some.few))
  for(j=1; j<=length(i.all); j += k) 
    push(i.all[j], few)
}
function _same(i,j,   ai,aj) {
  _few(i, ai)
  _few(j, aj)
  return cliffs(ai,aj)
}
function cliffs(as,bs,t,    a,b,n,lt,gt) {
  t= t? t : THE.stats.cliff
  for(a in as)
   for(b in bs) {
     n++
     if (as[a] < bs[b]) lt++
     if (as[a] > bs[b]) gt++
  }
  return abs(lt-gt)/n < t
}
```
