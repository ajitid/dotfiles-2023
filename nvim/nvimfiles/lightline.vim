" -----------------------
"  vim-startify Settings
" -----------------------

" Number of spaces for left padding
let g:startify_padding_left = 4

" List of sections in the start menu
let g:startify_lists = [                                                  
    \ { 'type': 'dir',       'header': ['    Recently Opened']},
    \ { 'type': 'bookmarks', 'header': ['    Bookmarks']      },
    \ { 'type': 'sessions',  'header': ['    Sessions']       },        
    \ { 'type': 'commands',  'header': ['    Commands']       },
    \ ]   

" List of commands
let g:startify_commands = [
    \ {'h': ['Check health',':checkhealth']},
    \ {'p': ['Install plugins', ':PlugInstall']},
    \ {'c': ['Clean plugins', ':PlugClean']},
    \ {'u': ['Update plugins', ':PlugUpdate']},
    \ ]

" Number of files to list
let g:startify_files_number = 5

" Changing directory is handled by vim-rooter
let g:startify_change_to_dir = 0

" Header
function! s:center(lines) abort
  let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
  let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
  return centered_lines
endfunction

" let g:startify_custom_header = s:center([
"     \ '    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗',
"     \ '    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║',
"     \ '    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║',
"     \ '    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║',
"     \ '    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║',
"     \ '    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝',
"     \ 'fdsfds'
"     \ ]
"     \ + split(strftime('%n    DATE: %A, %d/%m/%y%n    TIME: %R'), '\n'))

" let g:startify_disable_at_vimenter = 1
" let g:startify_custom_header = [g:FindRootDirectory()]

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


