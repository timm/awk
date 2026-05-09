# hello.awk -- smallest dot example: running mean of column 1

function num_init(it) { .it.n = 0; .it.mu = 0; return it }

function num_add(it, x) {
  .it.n++
  .it.mu += (x - .it.mu) / .it.n }

BEGIN { N = new("num") }

      { num_add(N, $1) }

END   { printf "n=%d mean=%.3f\n", .N.n, .N.mu }
