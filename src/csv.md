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

```awk
function csv(a,file,     j,b4, ready,line,x,y) {
  file  = file ? file : "-"           # [1]
  ready = getline < file
  if (ready<0) {
    print "#E> Missing file ["file"]"  # [2]
    exit 1
  }
  if (ready==0) {
    close(file)
    return 0
  }                                    # [3]
  line = b4 $0                         # [4]
  gsub(/([ \t]*|#.*$)/, "", line)      # [5]
  if (!line)
    return csv(a,file, line)           # [6]
  if (line ~ /,$/)
    return csv(a,file, line)           # [4]
  split(line, a, ",")                  # [7]
  for(j in a)  {
    x=a[j]
    y=a[j]+0
    a[j] = x==y? y : x }
  return 1
}
function cols(a,out,file,    ready,j,b) {
  if(!length(a)) 
      a["use"][1]=1
  ready = csv(b,file)
  if (ready<1) return 0
  if (length(a))
    for(j in a) out[j] = b[a[j]]
  return 1
}
```
