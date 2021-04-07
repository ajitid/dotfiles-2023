" using ftplugin/ folder would be better here
" ^ Update: maybe not in this case as I can comma separate Filetype here
let s:compe_c = {
			\ 'enabled': v:false,
			\ }
" passing 2nd arg which is bufnr as 0 targets current buffer, see https://github.com/hrsh7th/nvim-compe/issues/83#issuecomment-770232302
au FileType markdown call compe#setup(s:compe_c, 0)

let g:goyo_height='94%'
nnoremap <leader>tg <cmd>Goyo<cr>

function! s:goyo_enter()
	set scrolloff=999
	set nolazyredraw
	" ^ I've found flickering when creating newlines in zen mode when lazyredraw
	" is present
	echo ""

	" InsertCharPre causes issue as it is consumed by compe, when compe wasn't
	" disabled it said `pattern not found: lsp`, now when I have disabled it, it
	" says it is compe instead of lsp.
	" also with wrapping enabled, when it tries to center the cursor, the cursor
	" gets placed in incorrect position
	" Auto-scrolls to center when cursor is at end
	" https://stackoverflow.com/a/50027679/7683365
	" augroup autoCenter
	" 	autocmd!
	" 	autocmd InsertCharPre,InsertEnter * if (winline() * 3 >= (winheight(0) * 2))
	" 					\| norm! zz
	" 				\| endif
	" augroup END
endfunction

function! s:goyo_leave()
	" dunno how to properly disable it
	" au! autoCenter
	
	set lazyredraw
	set scrolloff=3
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
