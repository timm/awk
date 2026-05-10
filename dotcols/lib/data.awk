# data.awk -- Data: header parse + row table.
# Pure ingestion. No y/target logic, no splits. Apps add what they need.

function data_init(it) {
  arr(.it.cols); arr(.it.rows); arr(.it.all)
  arr(.it.y);    arr(.it.hdr);  arr(.it.nump)
  .it.nc = 0; .it.nrows = 0; .it.klass = 0; .it.ykind = ""
  return it }

function data_head(d, line,    i, n, f, name) {
  n = split(line, f, " *, *")
  .d.nc = n
  for (i = 1; i <= n; i++) {
    name = f[i]
    .d.hdr[i]  = name
    .d.nump[i] = (name ~ /^[A-Z]/)
    .d.cols[i] = new(.d.nump[i] ? "num" : "sym")
    if      (name ~ /-$/)  { .d.y[i] = 0; .d.ykind = "num" }
    else if (name ~ /\+$/) { .d.y[i] = 1; .d.ykind = "num" }
    else if (name ~ /!$/)  { .d.klass = i } }
  if (.d.ykind == "" && .d.klass) .d.ykind = "sym" }

function data_read(d, training,    r, i) {
  r = ++.d.nrows
  for (i = 1; i <= .d.nc; i++)
    .d.rows[r][i] = add(.d.cols[i], $i, training)
  if (training) .d.all[r] = r
  return r }

# clone a data's structure: same hdr/nump/y/klass, fresh empty col objs.
function data_clone(d,    nd, i) {
  nd = new("data")
  .nd.nc    = .d.nc
  .nd.klass = .d.klass
  .nd.ykind = .d.ykind
  for (i = 1; i <= .d.nc; i++) {
    .nd.hdr[i]  = .d.hdr[i]
    .nd.nump[i] = .d.nump[i]
    .nd.cols[i] = new(.d.nump[i] ? "num" : "sym") }
  for (i in .d.y) .nd.y[i] = .d.y[i]
  return nd }

# copy rows from src (selected by row_ids[k]=src_id) into dest, updating
# dest's col stats. each fed row gets a fresh dest-side id in .dest.rows / .dest.all.
function data_feed(dest, row_ids, src,    k, rid, i, r) {
  for (k in row_ids) {
    rid = row_ids[k]
    r   = ++.dest.nrows
    .dest.all[r] = r
    for (i = 1; i <= .dest.nc; i++) {
      .dest.rows[r][i] = .src.rows[rid][i]
      add(.dest.cols[i], .src.rows[rid][i], 1) } } }
