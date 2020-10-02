cat<<SED > /tmp/$$.sed
s/_All/_Col,_Num,_Sym/g
s/_Num/W,Hi,Lo/g
s/_Sym/Seen,Most.Mode/g
s/_Col/N,Use,Name,Some,Goal/g
SED

cat<<CODE | sed -f /tmp/$$.sed

function list(a,i) { a[i][0]; delete a[i][0] }
function header(_All,   i,c) {
  for(i=1;i<=NF;i++)
    if ($i!~/\?/ ) {
      c++
      Use[c]  = i
      Name[c] = $i
      list(Some,c)
      if ($i ~/!<>/) Goal[c]
      if ($i ~/:<>/)  {
        Num[c]
        W[c]  = ($i ~ /</) ? -1 : 1
        Hi[c] = -10^32
        Lo[c] =  10^32 }}
}
function keep(i) {
  if (length(Some[i]) < 
}
NR==1 { header() }
NR> 1 { for(i in Use[i]) D[NR-1][i] = $Use[i] }
CODE
