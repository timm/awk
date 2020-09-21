<a name=top>aa | aa | assaa | as<br>
<p align=center>
<h1>Gold</h1>
</p>
<hr>

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
