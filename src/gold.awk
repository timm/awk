# vim: ft=awk ts=2 sw=2 et :
BEGIN {DOT="."; DASH="_"}

#### object system
function isa(i,klass)    { Obj(i); i["isa"] = klass }
function List(i)         { split("",i,"") }
function Obj(i)          { List(i); i["isa"] = "Obj"; i["id"] = ++ID; return ID }
function zap(i,k)        { k=k?k:length(i)+1; i[k][0]; List(i[k]); return k } 
function has( i,k,f,  s) { f=f?f:"List"; s=zap(i,k); @f(i[k]); return s}
function hasmore(i,f)    { return has(i,"",f) }

#### unit testing
function ok(f,a,   n) { 
   a ? ++PASS : ++FAIL
   n = int(0.5+100*PASS/(PASS+FAIL+0.00001))"% : " f 
   print a ? green("Pass " n ) : red("Fail " n) 
}

function red(x)   { return "\033[31m"x"\033[0m" }
function green(x) { return "\033[32m"x"\033[0m" }

function tests(   fun,s) { 
  s= THE["stats"]["seed"]
  for(fun in FUNCTAB) 
    if(fun ~ /^ok./) {
      srand(s?s:1)
      @fun(fun)
  } 
  print((PASS?green("PASS " PASS):""),
        (FAIL ? red("FAIL " FAIL) : ""))
  rogues()
} 
function rogues(    s) {
  for(s in SYMTAB) 
    if (s ~ /^[A-Z][a-z]/) print red("#W> Global " s)>"/dev/stderr"
  for(s in SYMTAB) 
    if (s ~ /^[_a-z]/)     print red("#W> Rogue: " s)>"/dev/stderr"
}
