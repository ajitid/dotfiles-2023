nnoremap <c-p> <cmd>lua require('telescope.builtin').buffers({show_all_buffers = true})<cr>

" not entirely sure about old files `fh`, only thing being this should assist in
" ranking for `ff`

augroup goto_definition
    autocmd!
    autocmd FileType typescript,javascript,typescriptreact
        \ nnoremap <buffer><c-]> <cmd>lua require('telescope.builtin').lsp_definitions()<cr>
augroup END

" <silent> doesn't work here
nnoremap <leader>ia :Lspsaga code_action<CR>
vnoremap <leader>ia :<C-U>Lspsaga range_code_action<CR>

" nnoremap <leader>vf :lua M.search_dotfiles()<cr>
" nnoremap <leader>vf :lua require('/home/frefko/nvimfiles/telescope').search_dotfiles()<cr>

nnoremap <leader>e <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
nnoremap ]e :Lspsaga diagnostic_jump_next<CR>
nnoremap [e :Lspsaga diagnostic_jump_prev<CR>

" lua
" for _, mode in pairs({'n', 'v'}) do
" 	buf_set_keymap(mode, '[e', "<cmd>lua require'wb.lsp.diagnostics'.goto_prev({ severity_limit = 'Error' })<CR>", opts)
" end
