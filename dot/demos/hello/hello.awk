# hello.awk -- smallest dot example. Running mean of column 1.
# Uses only dot's runtime: new() + .field sugar. No Num/Sym, no dotcols.

BEGIN { N = new("plain") }
      { .N.n++; .N.mu += ($1 - .N.mu) / .N.n }
END   { printf "n=%d mean=%.3f\n", .N.n, .N.mu }
