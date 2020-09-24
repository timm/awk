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

# CSV Readers

Iterators for walking over files.

## Basic Csv reader

 `csv` complains if the file i missing,
skips empty lines, kills
whitespace and comments, splits on commas. 

As an added bonus,
if any line ends in a  comma, it is joined to the next line (so records can slit over N lines).

e.g.

     # e.g. reports the number of cells in each line
     while(csv(a,"data.csv")) 
        print length(a) 

```awk
@include "gold.awk"
@include "poly.awk"

function csv(a,file,     j,b4, ok,line,x,y) {
  file  = file ? file : "-"           
  ok = getline < file
  if (ok <0) { crash("missing "files) }
  if (ok==0) { close(file);return 0 }                                    
  line = b4 $0                         
  gsub(/([ \t]*|#.*$)/, "", line)      
  if (!line)       return csv(a,file, line)           
  if (line ~ /,$/) return csv(a,file, line)           
  split(line, a, ",")                  
  return 1
}
```

## Cols reader

Read a csv while ignoring columns whose header names
include "?". 
Coerce strings to numbers (if they need it).

Resulting  lines are  stored in `it`. e.g.

    # e.g. reports cells in each line, ignore the "?" columns
    Cols(ing, "data.csv")
    while (loop(ing)) {
        print length(ing.it) 

```awk
function Cols(i,file) {
  isa(i,"Cols")
  i.file = file
  has(i,"it")
  has(i,"some")
}
function _loop(i,    all,ok,want,where, old,new) {
  ok = csv(all,i.file)
  if (ok<1) return 0
  if (!length(i.some))
    for(want in all)
      if (all[want] !~ THE.ch.skip)
        i.some[want] = ++where
  for(want in i.some) {
    old = all[want]
    new = old + 0
    i.it[i.some[want]] = new==old ? new : old
  }
  return 1
}
```

This is an
example of nested iterators (the `Cols_loop` iterator is  defined using the `csv` iterator).
