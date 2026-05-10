# dot3 — resume notes

## status

`/Users/timm/gits/timm/awk/dot3/` — heap-free lua dialect with sugar transpiler.

- transpile.lua + lua/init.lua + bin/lawk : working
- nvim/ : syntax highlighting (vim + nvim/LazyVim)
- demos/showcase.lawk : runs cleanly, demonstrates every sugar
- NOT YET COMMITTED to git

## quick test (sanity)

```
cd /Users/timm/gits/timm/awk/dot3
./bin/lawk demos/showcase.lawk        # should print fib, squares, num stats
./bin/lawk demos/hello.lawk           # should print 5 lines incl [1,4,9,16,25]
```

## sugars implemented

| sugar | example |
|-------|---------|
| named arrow | `fib(n) =>\n  body .` |
| anon block | `f = (x) =>\n  body .` |
| anon inline | `inc = (x) => x + 1` |
| local sigil | `.x = expr`, `.x, y = a, b` |
| return sigil | `^expr` (line-start, after then/else/do/;) |
| end dots | `body .`, `body ..`, `body ...` (1/2/3 ends) |
| exponent | `a ** b` |
| import-all | `use math` (non-clobbering) |
| auto-pairs | `for k,v in IDENT do` |
| comprehension | `[expr for x in xs]` |

## nvim setup (LazyVim) — REQUIRED for colors

LazyVim disables vim-syntax by default; treesitter has no `lawk` parser.
Add to `~/.config/nvim/init.lua` (or a config file lazy will load):

```lua
vim.opt.runtimepath:prepend("/Users/timm/gits/timm/awk/dot3/nvim")
vim.api.nvim_create_autocmd("FileType", {
  pattern = "lawk",
  callback = function() vim.bo.syntax = "lawk" end,
})
```

After that, modeline `-- vim: set ft=lawk et ts=2 sw=2 :` in row 1 is enough.

## TODO

1. **Wire nvim init.lua** (the snippet above). Verify `nvim demos/showcase.lawk` lights up without manual `:set syntax=lawk`.

2. **Port real ezr.lua** end-to-end. /tmp/ezr_full_sugar.lawk has a partial sugar version (~60% of original); finish remaining sections (--act, --imagine, --classify, --bayes, --which, --sa, --ls, --compare, --cluster, --check, l.bin, l.unsuper, l.merge, l.cover, l.kmeans, l.kpp, l.same, l.bestRanks, l.confused, l.table, l.csv, l.items, l.bchop, l.o). Run, diff against ezr.lua output. Goal: byte-identical.

3. **Commit dot3** once ezr port verified:
   ```
   cd /Users/timm/gits/timm/awk
   git add dot3/
   git commit -m "add dot3: sugar transpiler for lua + nvim syntax"
   ```

4. **Edge cases to test:**
   - inline arrow split across lines: `sort(xs, (a,b) =>\n  a<b)` — does body terminator detection still work?
   - `**` inside string literal: should NOT be rewritten (skip_skipable handles)
   - nested `[expr for x in xs]` comprehensions
   - mixed sigil and explicit `local`

5. **Optional polish:**
   - add `lawk -t FILE.lawk` to dump cache path (currently `-c` prints transpiled)
   - tests dir with smoke tests (port from dot2/tests/ shape)
   - install.sh for `~/.config/nvim/` symlinks (simpler than manual init.lua edit)

## file map

```
dot3/
├── transpile.lua          # the rewrites (~270 lines)
├── lua/init.lua           # runtime helpers (comp, o, printf, ...)
├── bin/lawk               # bash wrapper, mtime-cached
├── demos/
│   ├── hello.lawk         # smoke
│   └── showcase.lawk      # all sugars
├── nvim/
│   ├── syntax/lawk.vim         # base (loads stock lua)
│   ├── after/syntax/lawk.vim   # extras
│   ├── ftdetect/lawk.vim       # vim ft detect
│   └── after/ftdetect/lawk.lua # nvim ft detect
└── TODO.md                # this file
```

## related

- /tmp/ezr_full_sugar.lawk : partial sugar port of ezr.lua (~30% saved)
- /tmp/ezr.lawk            : 214-line slice (older, stale)
- dot2/, dot2cols/, dot2learn/ : prior heap-free awk system (committed, master)
