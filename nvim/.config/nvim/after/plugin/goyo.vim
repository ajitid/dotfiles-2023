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
	set nolazyredraw
	echo ""

	augroup autoSave
		autocmd!
		autocmd TextChanged,TextChangedI <buffer> silent write
	augroup END
endfunction

function! s:goyo_leave()
	au! autoSave
	set lazyredraw
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
