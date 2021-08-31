BEGIN {
  rowsRead(tab,"../keys/data/weather.csv")
  oo(tab["col"])  }

#---------------------------------------------
function Rows(i,a,   name,c,what) {
  Obj(i)
  has(i,"row")
  has(i,"col")
  has(i,"name")
  for(c in a) {
    has(i["col"], c)
    name= = i{"name"][c]= a[c]
    what = name~ /^[A-Z]/ ? "Num" : "Sym"
    @what(i["col"][c], c, name
    if (name!~ /\?/) {
      name~ /[!-\+]/ ? i["y"][c]=  1 : i["x"][c] = 1
      if (name~ /-/)   i["y"][c]= -1} }}

function rows1(i, a) {
  length(i) ? rowsData(i,a) : Rows(i,a) } 

function rowsData(i,a,    c,x,r) {
  r = 1+length( tab["row"]  )
  for(c in a) {
    x = a[c]
    i["row"][r][c] = x 
    col1(i["col"][c],x) }}

function rowsRead(i,file,   a) {
  file = file ? file : "-"
  while ((getline < file)> 0) { split($0,a,","); rows1(i,a) }
  close(file) }

 #function _data1(col,x) {
 # function tabDist(tab,row1,row2,the) {
#   d=n=1E-31
#   for (c in tab[the["cols"]]) 
#      x=row1[c]; y =row1[c]
#      d=d+ (x==y=="?") ? 1 : (nump(tab["cols"][c]) ? numDist(
#      else {
#        d rowtab["cols"]
# x
# }
#---------------------------------------------
function Col(i,at, name) {
  Obj(i)
  i["n"] = 0
  i["at"] = at
  i["name"] = name
  if (name ~ /?/) i["skip"]=1 }

function col1(i, x) {
  if (x != "?") 
    if (! ("skip" in i)) {
      i["n"]++
      colNump(i) ?  num1(i,x) : sym1(i,x) }}

function colNump(i) { return "lo" in i}

#---------------------------------------------
function Num(i,at,name) {
  Col(i,at,name)
  i["lo"] =  1E32 
  i["hi"] = -1E32 
  i["mu"] =  i["m2"] = i["sd"] = 0 }

function num1(i,x,     d) {
  i["lo"]  = min(x, i["lo"]) 
  i["hi"]  = max(x, i["hi"]) 
  d          = x - i["mu"]
  i["mu"] += d/i["n"]
  i["m2"] += d*(x-i["mu"])
  i["sd"]  = (i["m2"] < 0) ? 0 : ( \
             (i["n"] < 2) ? 0 : (  \
              i["m2"]/(i["n"]-1))^0.5) }

function numNorm(i,x) {
   return (x-i["lo"])/(1E-31+ i["hi"] - i["lo"]) }

#---------------------------------------------
function Sym(i,at,name) {
  Col(i,at,name)
  has(i,"seen")
  i["mode"] = ""
  i["most"] = 0 }

function sym1(col,x,     old,new) {
  old = x in col["seen"] ? col["seen"][x] : 0
  new = col["seen"][x] = 1 + old
  if (new  > col["most"]) {
    col["most"]  = new
    col["mode"] = x}}

#---------------------------------------------
function min(x,y) { return x<y ? x : y }
function max(x,y) { return x>y ? x : y }
function has(a,i) { a[i][0]; delete a[i][0] }
function Obj(a)  { split("",a,"") }

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
