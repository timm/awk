-- ftdetect/lawk.lua -- treat .lawk files as the lawk filetype.
-- The lawk filetype loads stock lua syntax first, then layers
-- after/syntax/lawk.vim on top.
vim.filetype.add({ extension = { lawk = "lawk" } })
