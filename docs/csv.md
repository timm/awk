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

# CSV Readers

Iterators for walking over files.


## Basic Csv reader

 `csv` complains if the file i missing,
skips empty lines, kills
whitespace and comments, splits on commas, coerces strings to numbers (if they need it).

As an added bounus,
if any line ends in a  comma, it is joined to the next line (so records can slit over N lines).

e.g.

     # e.g. reports the number of cells in each line
     while(csv(a,"data.csv")) 
        print length(a) 

```awk
@include "gold.awk"

function csv(a,file,     j,b4, ok,line,x,y) {
  file  = file ? file : "-"           
  ok = getline < file
  if (ok <0) {print "#E> absent "file>"/dev/stderr";exit 1}
  if (ok==0) {close(file);return 0 }                                    
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


## Cols reader

Read a csv while ignoring columns whose header names
include "?". Each such line is stored in `it`. e.g.

    # e.g. reports cells in each line, ignore the "?" columns
    Cols(ing, "data.csv")
    while (Cols_loop(ing)) {
        print length(ing.it) 

```awk
function Cols(i,file) {
  isa(i,"Cols")
  i.file = file
  has(i,"it")
  has(i,"some")
}
function _loop(i,    all,ok,want,where) {
  ok = csv(all,i.file)
  if (ok<1) return 0
  if (!length(i.some))
    for(want in all)
      if (all[want] !~ THE.ch.skip)
        i.some[want] = ++where
  for(want in i.some)
    i.it[i.some[want]] = all[want]
  return 1
}
```

Note that this is an
example of nested iterators since  the `Cols_loop` iterator is  defined using the `csv` iterator.
