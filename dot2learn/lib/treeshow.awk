# treeshow.awk -- print a trained tree with per-y-goal column means.

function Tree_show(d, n,    i, name) {
  if (n.dep == 0) {
    printf "%-40s %6s %5s", "rule", "d2h", "n"
    for (i in d.y) printf " %8s", d.hdr[i]
    printf "\n" }
  Tree_show_walk(d, n) }

function Tree_show_walk(d, n,    pad, i, key, name) {
  pad = ""
  for (i = 0; i < n.dep; i++) pad = pad "|   "
  printf "%-40s %6.3f %5d", pad n.label, n.mu, n.nrows
  for (i in d.y) {
    name = d.hdr[i]
    printf " %8.2f", n.ymids[name] }
  printf "\n"
  if (n.kind == "branch")
    for (key in n.kids) Tree_show_walk(d, n.kids[key]) }
