# hello.awk -- smallest dot2 example. Running mean of column 1.
# Uses only dot2's runtime: new() + .field sugar. No Num/Sym, no dot2cols.

BEGIN { new(N, "plain") }
      { N.n++; N.mu += ($1 - N.mu) / N.n }
END   { printf "n=%d mean=%.3f\n", N.n, N.mu }
