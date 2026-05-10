" after/syntax/awk.vim -- extra highlighting for dot/dot2-style awk.
" Drop in ~/.config/nvim/after/syntax/awk.vim (or symlink).
" Layered on top of nvim's built-in awk syntax; nothing is replaced.
"
" Highlights:
"   it.foo           -> the ".foo" part as Identifier  (dot-sugar field)
"   Num(it)          -> "Num" as Type    (constructor: bare TitleCase ident)
"   Num_add(it,...)  -> "Num_add" as Function (Type_method convention)
"   new mk arr       -> Special (heap-free runtime)
"   add like var mid -> Function (polymorphic dispatchers)
"   THE.foo          -> "THE" as Constant, ".foo" as Identifier
"   PREP             -> Constant (build-time gate)

" --- dot-sugar field access: it.foo, d.cols[i].is, n.kids.lo ----------
" Match a dot followed by an ident, but only AFTER a value-char so we
" don't eat numeric literals (1.5) or regex dots inside /.../.
syntax match dotField    "\v([A-Za-z0-9_\]\)])@<=\.[A-Za-z_][A-Za-z_0-9]*"
hi def link dotField     Identifier

" --- constructors + type tags: Num, Sym, Data, Wins, Tree, Node ------
syntax keyword dotType   Num Sym Data Wins Tree Node
hi def link dotType      Type

" --- methods: Type_method (TitleCase prefix + _ + lowercase rest) ----
syntax match dotMethod   "\v<[A-Z][a-zA-Z0-9]+_[a-z][a-zA-Z0-9_]*>"
hi def link dotMethod    Function

" --- heap-free runtime (dot.awk) -------------------------------------
syntax keyword dotRuntime new mk arr rogues
hi def link dotRuntime   Special

" --- polymorphic dispatchers (numsym.awk) ----------------------------
" These collide with awk built-ins (split/length) — safe overrides since
" they're whole-word matches.
syntax keyword dotPoly   add like mid
hi def link dotPoly      Function

" Note: `var` is a gawk reserved-ish identifier; we override only when
" used as a function call.
syntax match dotVarCall  "\v<var>\ze\s*\("
hi def link dotVarCall   Function

" --- printer (dotlib.awk) --------------------------------------------
syntax keyword dotPrint  o _oo
hi def link dotPrint     Function

" --- distance / ML helpers (dotlearn) --------------------------------
syntax keyword dotHelper disty distx aha mids ycol y_eval
hi def link dotHelper    Function

" --- THE config table -------------------------------------------------
" Treat `THE` as a Constant (config name), and `.fieldname` after it
" already gets dotField via the rule above.
syntax keyword dotConfig THE PREP
hi def link dotConfig    Constant

" --- common globals (lowercase = leak per rogues()) -------------------
" Highlight HEAP / FUNCTAB / SYMTAB / NID for visibility.
syntax keyword dotBuiltin HEAP FUNCTAB SYMTAB NID FNR NR NF FS OFS RS
hi def link dotBuiltin   Constant
