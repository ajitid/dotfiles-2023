" to make hop.nvim shadow vim's `s`
nmap s <Nop>
xmap s <Nop>
nmap gs <Nop>
xmap gs <Nop>

lua require'hop'.setup { keys = 'fjdkslghaeiruvnmwo', teasing = false }
nnoremap <silent>s :HopChar2<cr>
xnoremap <silent>s <cmd>HopChar2<cr>
onoremap <silent>s :HopChar2<cr>
nnoremap <silent>gs :HopChar1<cr>
xnoremap <silent>gs <cmd>HopChar1<cr>
onoremap <silent>gs :HopChar1<cr>

