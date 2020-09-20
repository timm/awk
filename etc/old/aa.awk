prep() { gawk '
BEGIN { X["_num"] = "n,mu,m2,sd" }
function prep(s,  x) {
   for(x in X) gsub("\<"x"\>", X[x],s);return s}
}'
}
for i in *.awk; 
  prep $i > $HOME/opt/awk/$i; done
