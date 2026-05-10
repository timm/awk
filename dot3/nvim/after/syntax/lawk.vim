" after/syntax/lawk.vim -- syntax highlighting for .lawk files.
" Layered on top of stock lua syntax (loaded via ftdetect/lawk.lua).

" --- function name before (args) =>
"   matches: NAME, NUM.add, MOD.sub.foo  (idents with . or :)
syntax match lawkFnName        /\<[A-Za-z_][A-Za-z0-9_.:]*\ze\s*([^()]*)\s*=>/
hi def link lawkFnName         Function

" --- the => arrow itself (both block and inline)
syntax match lawkArrow         /=>/
hi def link lawkArrow          Special

" --- end-marker dots:  trailing space-dots at end of line
syntax match lawkEndDots       /\s\zs\.\+\s*$/
hi def link lawkEndDots        Statement

" --- local sigil:  .x = ...   (line-start, dot + ident before =)
syntax match lawkLocalSigil    /^\s*\.\ze[a-zA-Z_]/
hi def link lawkLocalSigil     Special

" --- return sigil:  ^expr  (line-start ^ followed by non-space)
syntax match lawkReturnSigil   /^\s*\^\ze\S/
hi def link lawkReturnSigil    Statement

" --- exponent **
syntax match lawkExp           /\*\*/
hi def link lawkExp            Operator

" --- use MOD  (import-all)
syntax match lawkUse           /^\s*use\s\+\S\+/
hi def link lawkUse            PreProc

" --- comprehension keywords inside [ ... for X in Y ]
syntax keyword lawkComp        for in containedin=ALL
hi def link lawkComp           Statement

" --- common runtime helpers (provided by lua/init.lua)
syntax keyword lawkRuntime     comp map filter reduce printf o each_line csv_split
hi def link lawkRuntime        Function

" --- def keyword (still recognized as alternative to NAME(args)=>)
syntax keyword lawkDef         def
hi def link lawkDef            Keyword
