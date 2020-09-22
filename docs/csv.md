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

Iterators for walking over files. `csv` complains if the file i missing,,
skips empty lines, kills
whitespace and comments, splits on commas, coerces strings to numbers (if they need it) and,
if any line ends in a  comma, it is joined to the next line (o records can slit over an times).
e.g.

     while(csv(a,"data.csv")) 
        print length(a) # reports the number of cells in each line

```awk
function csv(a,file,     j,b4, ready,line,x,y) {
  file  = file ? file : "-"           
  ready = getline < file
  if (ready <0) { print "#E> Missing file ["file"]";exit 1 }
  if (ready==0) { close(file);return 0 }                                    
  line = b4 $0                         
  gsub(/([ \t]*|#.*$)/, "", line)      
  if (!line)       return csv(a,file, line)           
  if (line ~ /,$/) return csv(a,file, line)           
  split(line, a, ",")                  
  for(j in a)  {
    x=a[j]
    y=a[j]+0
    a[j] = x==y? y : x }
  return 1
}
```
Read a csv while ignoring columns whose header names
include "?". Each such line is stored in `it`. e.g.

    Cols(ing, "data.csv")
    while (Cols_loop(ing)) {
        print length(ing.it) # reports the number of cells in each line

```awk
function Cols(i,file) {
  isa(i,"Cols")
  i.file = file
  has(i,"it")
  has(i,"some")
}
function _loop(i,    all,ready,want,where) {
  ready = csv(all,i.file)
  if (ready<1) return 0
  if (!length(i.some))
    for(want in all)
      if (all[want] !~ THE.ch.skip)
        i.some[want] = ++where
  for(want in i.some)
    i.it[i.some[want]] = all[want]
  return 1
}
```
