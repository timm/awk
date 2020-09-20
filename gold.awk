#!/usr/bin/env gawk -f
# vim: ft=awk ts=2 sw=2 et :
BEGIN {DOT="."; DASH="_"}
BEGIN{print 1}

function makes(file,dir, seen,       path,missing) {
  path = dir "/" file
  print "make "path > "/dev/stderr"
  print path > "/dev/stderr"
  if (++seen[path]>1) return 0
  if (seen[path]==1) 
    print "" > path
  while((getline < path)>0){ 
    print "getline "s > "/dev/stderr"
    missing=0; make($0,file,dir,seen) }
  close(path)
  if(missing) print "missing file: "file >"/dev/stderr"
}
function make(s,file,dir,seen,  a) {
  print "make1 "s > "/dev/stderr"
  if (s ~ /^@include/) 
    makes(gensub(/"([^"]+)"/,"\\1","g",s),dir,seen) 
  else {
    if (s ~ /^function/) {
      # kill any type hints in function call
      gsub(/:[A-Za-z0-9]+/,"",s)  
      # if this is a class, catch that name as a prefix
      if (s ~ /^function[ \t]+[A-Z][^\(]*\(/) {
        split(s,a,/[ \t\(]/)
        PREFIX = a[2] 
      }
      # add the prefix, where needed
      gsub(/_/,PREFIX "_",s)
    }
    # convert dots to accessor
    s= gensub( /\.([^0-9\\*\\$\\+])([a-zA-Z0-9_]*)/,
                "[\"\\1\\2\"]","g",s)
  }
  print s>> dir"/"file
}

function document(s, t,head,body,pre) {
  head = body = ""
  while(getline) 
    if (/^###[ $]?/) {
      s=""
      while(sub(/^[#]+[ $]?/,"")) { 
         s = s "\n" $0
         if (/^#/) head = head "\n" $0
         getline 
      }
      if (/^function /) {
        pre = /^function _?[A-Z]/ ? "\n### " : "\n#### "
        gsub(/(^function[ \t]*[_]?|{.*)/,"") 
        body = body pre $0  
        gsub(/\(.*/,"")
        head = head pre $0
      }
      gsub(/:[A-Za-z0-0]+/,"<em>&</em>",s)
      gsub(/Returns/,"\n<u><em>Returns</em></u>",s)
      body = body "\n" s
   }
   #print head "\n" body
   print  body
}

function oo(a,prefix,    indent,   i,txt) {
  txt = indent ? indent : (prefix "." )
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
function csv(a,file,     j,b4, status,line,x,y) {
  file   = file ? file : "-"           # [1]
  status = getline < file
  if (status<0) {
    print "#E> Missing file ["file"]"  # [2]
    exit 1
  }
  if (status==0) {
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
function cols(a,out,file,    status,j,b) {
  if(!length(a)) 
     a["it"][1] = a["use"][1]=1
  status = csv(b,file)
  if (status<1) return 0
  if (length(a))
    for(j in a) out[j] = b[a[j]]
  return 1
}

#### Conventions
### Objects
## - Objects are called `i` (and not `self`)
## - Object constructors are functions whose names start
##   with upper case. No other functions should start with uppercase.
## - Methods are functions whose names start with a dash `_`. At compile
##   time, this name gets a prefix of the last constructor.

### Notation
## - :str is a string
## - :num is a integer or float
## - :int is a number
## - :pos is a positive number
## - :atom is  a string or a number 
## - :list isa  list
## - :list0 is  a list or uninitialized 

### push(x:atom, a:list) :atom 
## Adds `x` to the end of `a`.
## Returns `x`.
function push(x,a)    { a[length(a)+1] =x; return x}

### isa(i:list0, thing:fun) :posint
## Ensures `i` is a `thing`.
## Resets `i` to the empty list, then adds `i.isa=y` and `i.id=n` 
## where `n` is a unique number.
## Returns  the newly created `i.id`.

### List(i:list0) :nil
## Resets `i` to the empty list 
function isa(i,klass)        { Obj(i); i["isa"] = klass }
function List(i)             { split("",i,"") }
function Obj(i)              { List(i); i["isa"] = "Obj"; i["id"] = ++ID; return ID }
function zap(i,k)            { k=k?k:length(i)+1; i[k][0]; List(i[k]); return k } 
function has( i,k,f,      s) { f=f?f:"List"; s=zap(i,k); @f(i[k]); return s}
function hasmore(i,f)        { return has(i,"",f) }

function max(x,y) { return x>y ? x : y }
function min(x,y) { return x<y ? x : y }

function red(x)   { return "\033[31m"x"\033[0m" }
function green(x) { return "\033[32m"x"\033[0m" }

function ok(f,a,n) { 
   a ? ++PASS : ++FAIL
   n = f " :"int(0.5+100*PASS/(PASS+FAIL+0.00001))"%"
   print a ? green("Pass " n ) : red("Fail " n) 
}
function allegs(   fun) { 
  for(fun in FUNCTAB) 
    if(fun ~ /^eg/) 
      @fun(fun) 
  
} 
function rogues(    s) {
  for(s in SYMTAB) 
    if (s ~ /^[A-Z][a-z]/) print "#W> Global " s>"/dev/stderr"
  for(s in SYMTAB) 
    if (s ~ /^[_a-z]/) print "#W> Rogue: " s>"/dev/stderr"
}

