" Telescope find commands and LSP
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>

" not entirely sure about old files `fh`, only thing being this should assist in
" ranking for `ff`
nnoremap <leader>fo <cmd>lua require('telescope.builtin').oldfiles()<cr>

nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>fc <cmd>lua require('telescope.builtin').command_history()<cr>

" nnoremap <leader>gd <cmd>lua vim.lsp.buf.definition()<cr>
nnoremap <leader>gd <cmd>lua require('telescope.builtin').lsp_definitions()<cr>
nnoremap <leader>ir <cmd>Lspsaga rename<cr>
nnoremap <silent><leader>ia :Lspsaga code_action<CR>
vnoremap <silent><leader>ia :<C-U>Lspsaga range_code_action<CR>
nnoremap <silent><leader>sh :Lspsaga hover_doc<CR>
nnoremap <silent><leader>ss :Lspsaga signature_help<CR>
" nnoremap <leader>vf :lua M.search_dotfiles()<cr>
" nnoremap <leader>vf :lua require('/home/frefko/nvimfiles/telescope').search_dotfiles()<cr>

" TODO: I prefer line level diagnostic rather just cursor, but check what jump next
" will do if there are two errors on the same line
nnoremap <leader>se <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>
nnoremap <leader>gen :Lspsaga diagnostic_jump_next<CR>
nnoremap <leader>gep :Lspsaga diagnostic_jump_prev<CR>
