" nnoremap <silent><leader>f<space> <cmd>lua require('telescope.builtin').buffers({show_all_buffers = true})<cr>

" not entirely sure about old files `fh`, only thing being this should assist in
" ranking for `ff`

" \ nnoremap <buffer><c-]> <cmd>lua require('telescope.builtin').lsp_definitions()<cr>
augroup goto_definition
    autocmd!
    autocmd FileType typescript,javascript,typescriptreact
        \ nnoremap <buffer><c-]> <cmd>lua vim.lsp.buf.definition()<cr>
        \| setlocal tagfunc=v:lua.tagfunc_nvim_lsp
augroup END

" <silent> doesn't work here
nnoremap <silent><leader>ia :Telescope lsp_code_actions<CR>
vnoremap <silent><leader>ia :<C-U>Telescope lsp_range_code_actions<CR>

" nnoremap <leader>vf :lua M.search_dotfiles()<cr>
" nnoremap <leader>vf :lua require('/home/frefko/nvimfiles/telescope').search_dotfiles()<cr>

nnoremap <leader>e <cmd>lua require'mine.lsp.diagnostics'.show_line_diagnostics()<CR>
command! EchoLineDiagnostics exec("lua require('mine.lsp.diagnostics').echo_line_diagnostics()")
nnoremap ]e <cmd>lua require'mine.lsp.diagnostics'.goto_next({ severity_limit = 'Error', wrap=false })<CR>
nnoremap [e <cmd>lua require'mine.lsp.diagnostics'.goto_prev({ severity_limit = 'Error', wrap=false})<CR>
nnoremap ]E <cmd>lua require'mine.lsp.diagnostics'.goto_next({ wrap=false })<CR>
nnoremap [E <cmd>lua require'mine.lsp.diagnostics'.goto_prev({ wrap=false })<CR>
command! PutErrorsInLocationList lua vim.lsp.diagnostic.set_loclist()
" automatically show line diagnostics:
" autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" for _, mode in pairs({'n', 'v'}) do
" 	buf_set_keymap(mode, '[e', "<cmd>lua require'wb.lsp.diagnostics'.goto_prev({ severity_limit = 'Error' })<CR>", opts)
" end

command! -nargs=1 IRenameVariable
  \ lua require('mine.lsp.rename').rename_variable(<f-args>)

