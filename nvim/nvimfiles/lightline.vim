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
       return '🔥 '.errors . ' 🚧 ' . warnings 
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

" modified `:h lightline-problem-12`
function! ModifiedMode()
    let map = { 'V': 'v-line', "\<C-v>": 'v-block', 's': 'select',
    \ 'v': 'visual', "\<C-s>": 'dunno-what-this-is', 'c': '≥ cmd', 'R': 'replace', 'n': 'normal', 'i': 'insert'}
    let mode = get(map, mode()[0], mode()[0])

    return mode
endfunction


" TODO: show tab/space and count
let g:lightline = {
      \ 'colorscheme': 'substratum',
      \ 'tabline': {
      \   'left': [['tabs']],
      \   'right': [[]]
      \ },
      \ 'active': {
      \   'left': [ [ 'filename', 'readonly', 'modified' ],
      \             [ 'modified-mode', 'paste' ] ],
      \   'right': [ [ 'lineinfo', 'percent' ],
      \              [ 'lsp_status', 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'inactive': {
      \   'left': [ [ 'filename', 'modified' ] ],
      \   'right': []
      \ },
      \ 'component': {
      \   'charvaluehex': '0x%B',
      \   'modified-mode': '%#ModifiedColor#%{ModifiedMode()}',
      \ },
      \ }

let g:lightline.component_expand = {
    \ 'lsp_status': 'LspStatus',
    \ }

let g:lightline.component_visible_condition = {
    \ 'lsp_status': 'not vim.tbl_isempty(vim.lsp.buf_get_clients(0))',
    \ }

autocmd User LspDiagnosticsChanged call lightline#update()


