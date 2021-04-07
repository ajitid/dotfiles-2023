source $HOME/.config/nvim/vim-plug/plugins.vim

" The modelines bit prevents some security exploits having to do with modelines in files. I never use modelines so I don't miss any functionality here. see http://lists.alioth.debian.org/pipermail/pkg-vim-maintainers/2007-June/004020.html
set modelines=0
" there might be a better solution for it, see:
" - https://news.ycombinator.com/item?id=20098691 and
" - https://github.com/ciaranm/securemodelines

" allow switching to a new buffer in the same window even if old buffer has
" some unsaved changes
set hidden

" By default typing space goes to next character
" This needs to be defined before leader commands are defined
nnoremap <space> <nop> 
let mapleader = "\<Space>" " map leader to space

if has('termguicolors')
  set termguicolors
endif

" need this to change cursor color https://github.com/neovim/neovim/issues/12626#issuecomment-799077796
set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor
aug kitty_cursor
    au!
    au Colorscheme * set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor
aug END

" theme
let g:embark_terminal_italics = 1
colorscheme embark

" hides default mode display as we are using custom statusline
set noshowmode
set laststatus=2

" Makes macros complete faster
set lazyredraw

" search for uppercase even if lowercase char is entered
set ignorecase
set smartcase

" Keep a column for gutter icons even if there is no icon present
" Yes I know there is `number` but introducing it makes me to think about the
" line number I want to jump
set signcolumn=yes

" Avoid showing message extra message when using completion
" Useful to hide Pattern not found in compe
set shortmess+=c

" For better completion experience
set completeopt=menuone,noinsert,noselect

" autosuggest max items
set pumheight=8

" lua require("init")
luafile ~/nvimfiles/lsp.lua
" luafile ~/nvimfiles/eslint-daemon.lua
" luafile ~/nvimfiles/lsp-eslint.lua
luafile ~/nvimfiles/telescope.lua
luafile ~/nvimfiles/lsp-saga.lua
" luafile ~/nvimfiles/lightbulb.lua
source ~/nvimfiles/compe.vim
source ~/nvimfiles/intelligent-keybindings.vim
source ~/nvimfiles/lightline.vim
luafile ~/nvimfiles/color-highlight.lua

" For easy command access and to not to lose `;` functionality
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" settings file, settings source
nnoremap <silent><leader>mf :tabe $MYVIMRC<cr>
nnoremap <leader>ms :source $MYVIMRC<cr>

" ctrl+s to save
inoremap <c-s> <esc><cmd>w<cr>h 
nnoremap <c-s> <esc><cmd>w<cr>

" relative line numbers
set number relativenumber

" number of lines to see below and above of cursor
set scrolloff=3

" use q to quickly escape out from help
autocmd Filetype help nnoremap <buffer> q :q<cr> 

" For a wrapped line which is lets say wrapped to 2 lines, vim will still
" treat it as a single line and so will jump over that 2nd line when navigated
" using j or k. This fixes that.
nmap k gk
nmap j gj
set wrap
set linebreak

" Highlight realtime when using find and replace by :s/old/new or
" when replacing all occurences of a line using :s/old/new/g. It also shows a 
" list in split window when replacing lines which are out of screen, by using,
" for example, :%s/old/new/g to replace all occurences in the file.
" set inccommand=split
" ^^ disabling this as I'm using markonm/traces.vim to have support for
" tpope/vim-abolish
let g:traces_abolish_integration = 1

" hls is annoying as I have to manually remove highlighting after I'm done
" (this could have been fixed with an easy vim autocmd but I don't know it
" much at this point of time
set nohls

" toggle highlight
" nnoremap <silent><expr> <Leader>th (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
" ^ same as below
nnoremap <silent><Leader>th <cmd>set hlsearch!<CR>

" quick tip: rather than pressing enter after search and using n and N to
" navigate, you can use <c-g> and <c-t>. It won't give you match count, it
" won't highlight all matches, sure, but it still feels faster getting to the
" target. One more tip, use \M at start of query to issue a non-magic search
" so you can search `.` without escaping it for example. For more, see :help \v.
nnoremap <leader>/ /\M
nnoremap <leader>? ?\M
" ^ or just use sneak

" Clear search highlights and cleans command area
nnoremap <silent><leader>l <cmd>noh<cr><cmd>echo ""<cr>

nnoremap <leader><space> <c-^>

" Toggle undo tree visualiser
" yep, fn keys can be mapped too-> 
" nnoremap <F5> <cmd>UndotreeToggle<cr> \| <cmd>UndotreeFocus<cr>
nnoremap <leader>tu <cmd>UndotreeToggle<cr> \| <cmd>UndotreeFocus<cr>

" markdown
" https://secluded.site/vim-as-a-markdown-editor/
" TODO: typewriter mode on line end too

" highlight yanked text
augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank {higroup="IncSearch", timeout=350}
augroup END

" Smooth scroll
let g:smoothie_base_speed = 20

" preserve and cycle yanked contents
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
nmap [p <plug>(YoinkPostPasteSwapBack)
nmap ]p <plug>(YoinkPostPasteSwapForward)
let g:yoinkAutoFormatPaste = 1
nmap =p <plug>(YoinkPostPasteToggleFormat)

" System clipboard operations
" Yank into + buffer
nmap <leader>y "+y
vmap <leader>y "+y
nmap <leader>Y "+Y
vmap <leader>Y "+Y
" Paste from + buffer
nmap <leader>p "+p
vmap <leader>p "+p
nmap <leader>P "+P
vmap <leader>P "+P

" Rooter
let g:rooter_patterns = ['src', '.git', 'Makefile', 'node_modules']

let g:startify_session_persistence = 1
let g:startify_session_savevars = [                                                                                            
     \ 'g:startify_session_savevars',   
     \ 'g:startify_session_savecmds',
     \ ]

" Copies active file path to default/system clipboard register
" If you are tabbing between a file in project and an empty file, absolute
" path is mistakingly yanked. So first time yank is send to null register
" (otherwise known as black hole register), we tab away and then tab
" back to the active file and finally we copy its relative path. 
" To copy absolute path or filename, see https://stackoverflow.com/q/916875 or
" even better https://stackoverflow.com/questions/27448157/copy-only-filename-without-extension-to-system-clipboard
" Further reading-> :help filename-modifiers
nnoremap <leader>cp <cmd>let @_ = expand("%")<cr>gtgT<cmd>let @" = expand("%")<cr>
nnoremap <leader>Cp <cmd>let @_ = expand("%")<cr>gtgT<cmd>let @+ = expand("%")<cr>

nnoremap <leader>cn <cmd>let @_ = expand("%:t")<cr>gtgT<cmd>let @" = expand("%:t")<cr>
nnoremap <leader>Cn <cmd>let @_ = expand("%:t")<cr>gtgT<cmd>let @+ = expand("%:t")<cr>

" Swaps block of code, respecting indentation of blocks in which it is swapped
" to (esp. useful in visual line mode)
" This breaks multi-line join, so I'm not entirely sure what to do about it.
vnoremap <c-j> :m '>+1<cr>gv=gv
vnoremap <c-k> :m '<-2<cr>gv=gv

" Paste last explicit yank made
nnoremap <leader>v "0p
nnoremap <leader>V "0P
vnoremap <leader>v "0p
vnoremap <leader>V "0P

" Trigger which key on timeout
nnoremap <silent> <leader> :WhichKey '<Space>'<CR>

" dir viewer sort folders at top
let g:dirvish_mode = ':sort ,^.*[\/],'

" quick horizontal find
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" add `_` as a delimiter for small words
" set iskeyword-=_
" ^ this will break syntax highlighting if you'll do `function
" App_something()` in TSX file for example, see https://til.hashrocket.com/posts/uanfzuizgu-change-up-to-next-underscore-in-vim
" and https://unix.stackexchange.com/questions/110599/vim-avoid-selecting-underscore

" Undotree vis toggle
" persist undo state by storing it in an external file
if has("persistent_undo")
   let target_path = expand('~/nvimfiles/.undodir')

    " create the directory and any parent directories
    " if the location does not exist.
    if !isdirectory(target_path)
        call mkdir(target_path, "p", 0700)
    endif

    let undodir=target_path
    set undofile
endif

" Quick scope (horizontal navigation using find) token colors
highlight QuickScopePrimary guifg='#6bdeba' gui=underline ctermfg=81
highlight QuickScopeSecondary guifg='#ffc4a4' gui=underline ctermfg=81

" create new file relattive to current file, use `:e ` to create one wrt root
" of project. We are using <c-z> to simulate tab, see
" https://stackoverflow.com/questions/32513835/create-vim-map-that-executes-tab-autocomplete
" Also, we are using : over <cmd> so vim doesn't ask us to append <cr> at the
" end. More separators here ->
" http://vimdoc.sourceforge.net/htmldoc/cmdline.html#filename-modifiers
set wildcharm=<c-z>
nnoremap <leader>n :e %:.:h<c-z>

" Go to location (line no, col no)
nnoremap gl :call cursor()<left>

" vim abolish substitute
vnoremap ss :S///g<left><left><left>

" reselect the text that was just pasted, and indent it
" V = visually select lines, `] = till end of paste, = = indent
" useful for formatting system clipboard contents
nnoremap <leader>= V`]
" might be relevant https://stackoverflow.com/a/7087202/7683365

" to format on paste, use ]p and with a register it'll become "0]p
" you might need p=`] over ]p, see Correcting bad indent while pasting from
" https://vim.fandom.com/wiki/Format_pasted_text_automatically. That being
" said, it never affected me. (Update: I installed a plugin for this)
" in insert mode fomat+paste will be <c-r><c-p>{regname}



" sane window navigation
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

tnoremap <A-h> <c-\><c-n><C-w>h
tnoremap <A-j> <c-\><c-n><C-w>j
tnoremap <A-k> <c-\><c-n><C-w>k
tnoremap <A-l> <c-\><c-n><C-w>l
tnoremap <Esc> <c-\><c-n>
tnoremap <A-[> <Esc>

" natural split opening (also helps in autoswitching to new window), stolen from
" https://thoughtbot.com/blog/vim-splits-move-faster-and-more-naturally
set splitbelow
set splitright

" command line abbreviation (no need to hit tab, just type :nt and press
" enter)
ca nt tabnew
" There is this too -> command! Wq wq

" stop rooter plugin to echo on start in msgs
let g:rooter_silent_chdir = 1

" to make vim sandwich shadow vim's `s`
nmap s <Nop>
xmap s <Nop>

" visual * or # search, don't consume my leader pls, I'll copy the text and
" pass it to telescope grep instead:
" nnoremap <leader>* <Nop>
" vnoremap <leader>* <Nop>
" that being said i am replacing vimgrep with `rg` so I might revoke Nop
" keybinding above
if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif
" TODO: in telescope use grep instead of vimgrep and rg, in above code show
" hidden files but exclude .git repo, make visual star search to use grep
" instead of vimgrep, also see https://github.com/romainl/vim-qf

set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*,*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls,*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*/dist/*,*/build/*,.idea/**,*DS_Store*,*/coverage/*,*/.git/*,*/package-lock.json

function! s:CreateDirsForCurrentFile()
  call mkdir(expand("%:h"),"p")
endfunction
command! -bar -nargs=? CreateDirsForCurrentFile
  \ call s:CreateDirsForCurrentFile()

" sneak mode, jump to
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
" embark
highlight SneakScope guifg=#1e1c31 guibg=#91ddff ctermfg=red ctermbg=yellow
highlight Sneak guifg=#cbe3e7 guibg=#3e3859 ctermfg=black ctermbg=red
" 2-character Sneak (default)
nmap <leader>j <Plug>Sneak_s
nmap <leader>k <Plug>Sneak_S
" visual-mode
xmap <leader>j <Plug>Sneak_s
xmap <leader>k <Plug>Sneak_S
" operator-pending-mode
omap <leader>j <Plug>Sneak_s
omap <leader>k <Plug>Sneak_S

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stab call Stab()
function! Stab()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  call SummarizeTabs()
endfunction

function! SummarizeTabs()
  try
    echohl ModeMsg
    echon 'tabstop='.&l:ts
    echon ' shiftwidth='.&l:sw
    echon ' softtabstop='.&l:sts
    if &l:et
      echon ' expandtab'
    else
      echon ' noexpandtab'
    endif
  finally
    echohl None
  endtry
endfunction
" ^ logs on the same line on which it has taken input
" TODO: also i need a way to re-indent whole buffer without moving the cursor just
" like %y

" return to last cursor position on file open by using `"` mark
" taken from vim user manual, also see https://stackoverflow.com/a/40992753/7683365
" also see https://stackoverflow.com/questions/8854371/vim-how-to-restore-the-cursors-logical-and-physical-positions
" and https://github.com/farmergreg/vim-lastplace
au BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif

" nobody got time to write `gcc` to comment one line, I'll use ctrl+/ instead
nnoremap <c-_> <cmd>Commentary<cr>

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
  " augroup autoCenter
  "   autocmd!
  "   autocmd InsertCharPre,InsertEnter * if (winline() * 3 >= (winheight(0) * 2))
  "         \| norm! zz
  "         \| endif
  " augroup END
  echo ""
endfunction

function! s:goyo_leave()
  " au! autoCenter
  set scrolloff=3
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" repeats last macro, @: repeats last command
nnoremap Q @@
