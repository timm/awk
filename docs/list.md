<a name=top>
<h2>
     The Gawk Object Layer
</h2>
<p>
   <a    href="https://github.com/timm/awk/blob/masterREADME.md#license">license</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#install">install</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#contribute">contribute</a>
   :: <a href="https://github.com/timm/awk/issues">issues</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#citation">cite</a>
   :: <a href="https://github.com/timm/awk/blob/master/README.md#contatct">contact</a>
<br>
   <img src="https://img.shields.io/badge/language-gawk-orange">
   <img src="https://img.shields.io/badge/purpose-ai,se-blueviolet">
   <img src="https://img.shields.io/badge/platform-mac,*nux-informational">
</p>

```awk
function push(x,a) { a[length(a)+1] =x;return x }

function oo(a,prefix,    indent,   i,txt) {
  txt = indent ? indent : (prefix DOT )
  if (!isarray(a)) {print(a); return a}
  ooSortOrder(a)
  for(i in a)  {
    if (isarray(a[i]))   {
      print(txt i"" )
      oo(a[i],"","|  " indent)
    } else
      print(txt i (a[i]==""?"": ": " a[i])) }
}
function ooSortOrder(a, i) {
  for (i in a)
   return PROCINFO["sorted_in"] =\
     typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc"
}
```
