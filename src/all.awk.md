#!/usr/bin/env ["/gold"]
# vim: filetype=awk : 

asdasdasdasda
asdasdasadsasdasd
asdassaads

    
    BEGIN {
      DOT=sprintf("%c",46)
      Obj(i)
      rowsRead(i,DOT DOT "/keys/data/weather"DOT"csv")
      oo(i) 
    }

# asdasd

- asdasadasd
asdadasdasdasdas
aasdadasdsa
asdasasdadsdasasddasd    

    #---------------------------------------------
    function Rows(i,a,   name,c,what) {
      Obj(i)
      i["is"]="rows"
      has(i,"row")
      has(i,"col")
      has(i,"name")
      for(c in a) {
        has(i["col"], c)
        name = i["name"][c]= a[c]
        what = name ~ /^[A-Z]/ ? "Num" : "Sym"
        if (name ~ /?/) what="Skip"
        @what(i["col"][c], c, name)
        if (name !~ /\?/) {
          name~ /[!-\+]/ ? i["y"][c]=  1 : i["x"][c] = 1
          if (name~ /-/)   i["y"][c]= -1 }}}
    
    function rows(i, a) {
      length(i) ? _rows(i,a) : Rows(i,a) } 
    
    function _rows(i,a,    c,x,r) {
      r = 1 + length( tab["row"]  )
      for(c in a) 
        i["row"][r][c] = colAdd(i["col"][c], a[x])}
    
    function rowsRead(i,file,   a) {
      file = file ? file : "-"
      while ((getline < file)> 0) { split($0,a,","); rows(i,a) }
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
    function add(i,x,f) {f=i["is"]"Add"; return @f(i,x) }
    #---------------------------------------------
    function Col(i,at, name) {
      Obj(i)
      i["is"]="col"
      i["n"] = 0
      i["at"] = at
      i["name"] = name
      if (name ~ /?/) i["skip"]=1 }
    
    function colAdd(i, x) {
      if (x != "?") {
          i["n"]++
          x = add(i,x) }
      return x }
    
    #---------------------------------------------
    function Skip(i,at,name) { Col(i,at,name); i["is"]="skip" }
    
    function skipAdd(i,x) { return x }
    
    #---------------------------------------------
    function Num(i,at,name) {
      Col(i,at,name)
      i["is"]="num"
      i["lo"] =  1E32 
      i["hi"] = -1E32 
      i["mu"] =  i["m2"] = i["sd"] = 0 }
    
    function numAdd(i,x,     d) {
      if(x< i["lo"]) i["lo"] = x
      if(x> i["hi"]) i["hi"] = x
      d     = x - i["mu"]
      i["mu"] += d/i["n"]
      i["m2"] += d*(x-i["mu"])
      i["sd"]  = (i["m2"] < 0) ? 0 : ( \
              (i["n"]  < 2) ? 0 : (  \
               i["m2"]/(i["n"]-1))^0.5) }
    
    function norm(i,x) {
       return (x-i["lo"])/(i["hi"] - i["lo"] +1E-31) }
    
    #---------------------------------------------
    function Sym(i,at,name) {
      Col(i,at,name)
      has(i,"seen")
      i["mode"] = ""
      i["most"] = 0 }
    
    function symAdd(col,x,     old,new) {
      old = x in col["seen"] ? col["seen"][x] : 0
      new = col["seen"][x] = 1 + old
      if (new  > col["most"]) {
        col["most"]  = new
        col["mode"] = x }}
    
    #---------------------------------------------
    function has(a,i) { a[i][0]; delete a[i][0] }
    function Obj(a)   { split("",a,"") }
    
    function oo(x,p,pre, i,txt) {
      txt = pre ? pre : (p DOT)
      _ooOrder(x)
      for(i in x)  {
        if (isarray(x[i]))   {
          print(txt i"" )
          oo(x[i],"","|  " pre)
        } else
          print(txt i (x[i]==""?"": ": " x[i])) }
    }
    function _ooOrder(x,   i) {
      for (i in x)
        return PROCINFO["sorted_in"] =\
          typeof(i+1)=="number" ? "@ind_num_asc" : "@ind_str_asc"
    }
