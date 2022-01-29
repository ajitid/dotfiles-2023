" wildfire.vim {{
let g:wildfire_objects = ["i'", 'i"', "i)", "i]", "i}", "ip", "it"]
" }}

" harpoon {{
nnoremap <leader>ma <cmd>lua require("harpoon.mark").add_file()<cr><cmd>echo 'File added to Harpoon:' expand('%')<cr>
nnoremap <leader>mm <cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>

function! s:Harpoo(count) abort
  if a:count > 0
    call luaeval('require("harpoon.ui").nav_file(' . a:count . ')')
  endif
endfunction

nnoremap <leader>j <cmd>call <sid>Harpoo(v:count1)<cr>

function! s:HarpooTerm(count) abort
  if a:count > 0
    call luaeval('require("harpoon.term").gotoTerminal(' . a:count . ')')
  endif
endfunction

nnoremap <leader>k <cmd>call <sid>HarpooTerm(v:count1)<cr>
" }}
