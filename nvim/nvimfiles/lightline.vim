" LSP status in statusline
function! LspStatus() abort
    let sl = ''
    "  if luaeval('#vim.lsp.buf_get_clients() > 0')
    if luaeval('not vim.tbl_isempty(vim.lsp.buf_get_clients(0))')
       let errors = luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Error]])")
       let warnings = luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Warning]])")
       let info = luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Hint]])")
       " let warnings = luaeval("vim.lsp.diagnostic.get_count(vim.fn.bufnr('%'), [[Warning]])")
       if errors == 0 && warnings == 0
           return '✨'
       endif
       " return '🙅 '.errors . ' 🐛 ' . warnings . ' ℹ ' . info
       return '🔥 '.errors . ' 🐛 ' . warnings 
        " return luaeval("require('lsp-status').status()")
        " let sl.='%#MyStatuslineLSP#E:'
        " let sl.='%#MyStatuslineLSPErrors#%{luaeval("vim.lsp.diagnostic.get_count([[Error]])")}'
        " let sl.='%#MyStatuslineLSP# W:'
        " let sl.='%#MyStatuslineLSPWarnings#%{luaeval("vim.lsp.diagnostic.get_count([[Warning]])")}'
    else
        return ''
    endif
    return sl
endfunction

" TODO: show tab/space and count
let g:lightline = {
      \ 'colorscheme': 'substratum',
      \ 'tabline': {
      \   'left': [['tabs']],
      \   'right': [[]]
      \ },
      \ 'active': {
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'lsp_status' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ ['filename', 'modified'] ],
      \   'right': []
      \ },
      \ 'component': {
      \   'charvaluehex': '0x%B'
      \ },
      \ }

let g:lightline.component_expand = {
    \ 'lsp_status': 'LspStatus',
    \ }

let g:lightline.component_visible_condition = {
    \ 'lsp_status': 'not vim.tbl_isempty(vim.lsp.buf_get_clients(0))',
    \ }

autocmd User LspDiagnosticsChanged call lightline#update()


