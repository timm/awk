<a name=top>
<h2>
     The Gawk Object Layer
</h2>
<p>
   <a    href="http://menzies.us/awk/index">docs</a>
   :: <a href="http://menzies.us/awk/index#license">license</a>
   :: <a href="http://menzies.us/awk/index#install">install</a>
   :: <a href="http://menzies.us/awk/index#contribute">contribute</a>
   :: <a href="http://github.com/timm/awk/issues">issues</a>
   :: <a href="http://menzies.us/awk/index#cite">cite</a>
   :: <a href="http://menzies.us/awk/index#contatct">contact</a>
<br>
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
