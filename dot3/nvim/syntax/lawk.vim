" syntax/lawk.vim -- base syntax for the lawk filetype.
" Loads stock lua syntax (since lawk is a superset), then leaves
" after/syntax/lawk.vim to add the new tokens.

if exists("b:current_syntax")
  finish
endif

runtime! syntax/lua.vim
unlet! b:current_syntax
let b:current_syntax = "lawk"
