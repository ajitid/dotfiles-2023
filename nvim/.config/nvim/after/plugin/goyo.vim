" using ftplugin/ folder would be better here
" ^ Update: maybe not in this case as I can comma separate Filetype here
let s:compe_c = {
			\ 'enabled': v:false,
			\ }
" passing 2nd arg which is bufnr as 0 targets current buffer, see https://github.com/hrsh7th/nvim-compe/issues/83#issuecomment-770232302
au FileType markdown call compe#setup(s:compe_c, 0)

let g:goyo_height='94%'
nnoremap <leader>tg <cmd>Goyo<cr>

function! s:sambhalo()
	let b:first_visible_line_no = line("w0")
	let b:curr_line_no = line('.')
	let b:lines_diff = b:curr_line_no - b:first_visible_line_no
	echo b:lines_diff
	" norm! 
endfunction

function! s:goyo_enter()
	set nolazyredraw
	echo ""

	" this needs throttling or something of 2 mins, and save on insert mode exit
	" augroup autoSave
	" 	autocmd!
	" 	autocmd TextChanged,TextChangedI <buffer> silent write
	" augroup END

	" augroup autoCenter
	" 	autocmd!
	" 	" nah-> autocmd InsertEnter,InsertCharPre <buffer> call s:sambhalo()
	" 	autocmd InsertEnter,CursorMovedI <buffer> call s:sambhalo()
	" augroup END
	" with this we could have solve it using winline() and winheight(), but to
	" make actual scroll using ctrl-y and ctrl-e, these scrolling mechanisms use
	" line jumping skip line wraps. There is an issue on about the same in
	" neovim repo.
endfunction

function! s:goyo_leave()
	" au! autoSave
	set lazyredraw
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
