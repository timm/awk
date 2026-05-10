# data.awk -- Data: header parse + row table.
# Pure ingestion. No y/target logic, no splits. Apps add what they need.

function Data(it) {
  new(it, "Data")
  arr(it.cols); arr(it.rows); arr(it.all)
  arr(it.y);    arr(it.hdr);  arr(it.nump)
  it.nc = 0; it.nrows = 0; it.klass = 0; it.ykind = "" }

function Data_head(d, line,    i, n, f, name) {
  n = split(line, f, " *, *")
  d.nc = n
  for (i = 1; i <= n; i++) {
    name = f[i]
    d.hdr[i]  = name
    d.nump[i] = (name ~ /^[A-Z]/)
    mk(d.cols[i], d.nump[i] ? "Num" : "Sym")
    if      (name ~ /-$/)  { d.y[i] = 0; d.ykind = "Num" }
    else if (name ~ /\+$/) { d.y[i] = 1; d.ykind = "Num" }
    else if (name ~ /!$/)  { d.klass = i } }
  if (d.ykind == "" && d.klass) d.ykind = "Sym" }

function Data_read(d, training,    r, i) {
  r = ++d.nrows
  for (i = 1; i <= d.nc; i++)
    d.rows[r][i] = add(d.cols[i], $i, training)
  if (training) d.all[r] = r
  return r }

# clone d's structure into nd: same hdr/nump/y/klass, fresh empty col objs.
function Data_clone(nd, d,    i) {
  Data(nd)
  nd.nc    = d.nc
  nd.klass = d.klass
  nd.ykind = d.ykind
  for (i = 1; i <= d.nc; i++) {
    nd.hdr[i]  = d.hdr[i]
    nd.nump[i] = d.nump[i]
    mk(nd.cols[i], d.nump[i] ? "Num" : "Sym") }
  for (i in d.y) nd.y[i] = d.y[i] }

# copy rows from src (selected by row_ids[k]=src_id) into dest, updating
# dest's col stats. each fed row gets a fresh dest-side id.
function Data_feed(dest, row_ids, src,    k, rid, i, r) {
  for (k in row_ids) {
    rid = row_ids[k]
    r   = ++dest.nrows
    dest.all[r] = r
    for (i = 1; i <= dest.nc; i++) {
      dest.rows[r][i] = src.rows[rid][i]
      add(dest.cols[i], src.rows[rid][i], 1) } } }
