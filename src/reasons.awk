function list(a)               { split("",a,"") }
function has(a,k,x)           { x=x?x:"list"; a[k][0]; delete a[k][0]; @f(new) }
function have(x,slots,   a,i) { split(slots,a,","); for(i in a) has(x,a[i])}
function more(a,x,   k)   {  has(a,1+length(a),x) }

function read(file,fun,it,     a) {
  file=file?file:"-"
  while((getline file) > 0) {
    gsub(/([ \t\r]*|#.*)/,"")
    split($0,a,",")
    @fun(a,it) }
  close(file) }

function col(i,at,txt){ 
  list(i)
  i.at=at; i.txt=txt; i:n=0 
  i.w = txt~/\+$/ ? 1 : (txt~/-$/) ? -1 : 0) }

function num(i,at,txt) { col(i,at,txt);i.lo=1E31; i.hi=-1E31} 
function sym(i,at,txt) { col(i,at,txt); has(i,"seen") }
function sample(i)     { list(i); has(i,"rows"); has(i"cols") }

function main(file,     it) {
  has("it",cols) }
    

BEGIN{ split("",lo,""); split("",hi,"") {
NR==1{ for(i=1;i<=NF;i++) name[$i] = i
       for(i in name) if (name[i] ~ /^[A-Z]/) {lo[i]=1E31; hi[i]=-1E31}
       next}
     { forif(i in lo) {
         $i = $i+0
         if ($i > hi[i]) hi[i]=$i
         if ($i < lo[i]) lo[i]=$i }
      }
END {

