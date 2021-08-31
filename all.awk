BEGIN {
  list(tab)
   read(tab,"../keys/data/weather.csv")
  oo(tab["col"])  }

function read(tab,file,   a) {
  file = file ? file : "-"
  while ((getline < file)> 0) { split($0,a,",");sample1(tab,a) }
  close(file) }

function sample1(tab,a) {
  length(tab) ? data1(tab,a) : sample0(tab,a) } 
 
function data1(tab,a,    i,x,r) {
  r = 1+length( tab["row"]  )
  for(i=1;i<=length(a);i++) {
    x = a[i]
    col1( tab["col"][i], x)
    tab["row"][r][i] = x }}

function sample0(tab,a,   x,i) {
  has(tab,"row")
  has(tab,"col")
  for(i=1;i<=length(a);i++) {
    has(tab["col"], i)
    x = a[i]
    col0(tab["col"][i],i, x)
    if (x !~ /\?/) {
      x ~ /[!-\+]/ ? tab["y"][i]=  1 : tab["x"][i] = 1
      if (x ~ /-/)   tab["y"][i]= -1} }}

function col0(col,i, x) {
  col["n"] = 0
  col["at"] = i
  col["name"] = x
  if (x ~ /?/)   
    col["skip"]=1
  else
   x ~ /^[A-Z]/ ? num0(col)   : sym0(col) }

function num0(col) {
  col["lo"] =  1E32 
  col["hi"] = -1E32 
  col["mu"] =  col["m2"] = col["sd"] = 0 }

function sym0(col) {
  has(col,"seen")
  col["mode"] = ""
  col["most"] = 0 }

function nump(col) { return "lo" in col}

function col1(col,x) {
  if (x != "?") {
    col["n"]++
    if (! ("skip" in col))
      nump(col) ?  num1(col,x) : sym1(col,x) }}

function sym1(col,x,     old,new) {
  old = x in col["seen"] ? col["seen"][x] : 0
  new = col["seen"][x] = 1 + old
  if (new  > col["most"]) {
    col["most"]  = new
    col["mode"] = x}}

function num1(col,x,     d) {
  col["lo"]  = min(x, col["lo"]) 
  col["hi"]  = max(x, col["hi"]) 
  d          = x - col["mu"]
  col["mu"] += d/col["n"]
  col["m2"] += d*(x-col["mu"])
  col["sd"]  = (col["m2"] < 0) ? 0 : ( \
               (col["n"]  < 2) ? 0 : (  \
               col["m2"]/(col["n"]-1))^0.5) }

function norm(col,x) {
   return (x-col["lo"])/(1E-31+ col["hi"] - col["lo"]) }

function tabDist(tab,row1,row2,the) {
  d=n=1E-31
  for (c in tab[the["cols"]]) 
     x=row1[c]; y =row1[c]
     d=d+ (x==y=="?") ? 1 : (nump(tab["cols"][c]) ? numDist(
     else {
       d rowtab["cols"]
x
}
function min(x,y) { return x<y ? x : y }
function max(x,y) { return x>y ? x : y }
function has(a,i) { a[i][0]; delete a[i][0] }
function list(a) { split("",a,"") }

function oo(x,p,pre, i,txt) {
  txt = pre ? pre : (p DOT)
  ooSortOrder(x)
  for(i in x)  {
    if (isarray(x[i]))   {
      print(txt i"" )
      oo(x[i],"","|  " pre)
    } else
      print(txt i (x[i]==""?"": ": " x[i])) }
}
function ooSortOrder(x, i) {
  for (i in x)
    return PROCINFO["sorted_in"] =\
      typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc"
}

