source $HOME/.config/nvim/plugins.vim

" ~/nvimfiles/eh.md

" ~ filled at end is now replaced by a space
set fillchars=eob:\ ,

set shm+=I

" which key prompt wait time
set timeoutlen=1500

" cursor hold time
" set updatetime=700
" from FixCursorHold.nvim
let g:cursorhold_updatetime = 400

" The modelines bit prevents some security exploits having to do with modelines in files. I never use modelines so I don't miss any functionality here. see http://lists.alioth.debian.org/pipermail/pkg-vim-maintainers/2007-June/004020.html
set modelines=0
" there might be a better solution for it, see:
" - https://news.ycombinator.com/item?id=20098691 and
" - https://github.com/ciaranm/securemodelines
" there is also `secure` https://vi.stackexchange.com/questions/5055/why-is-set-exrc-dangerous
" I believe that ii14/exrc.vim which I've installed helps to guard this

" allow switching to a new buffer in the same window even if old buffer has
" some unsaved changes
set hidden

" see netrw-noload
" commented to allow running GBrowse of fugitive, and custom gf command
" let g:loaded_netrw       = 1
" let g:loaded_netrwPlugin = 1


" Highlight realtime when using find and replace by :s/old/new or
" when replacing all occurences of a line using :s/old/new/g.
set inccommand=nosplit
" ^^ disabling this as I'm using markonm/traces.vim to have support for
" tpope/vim-abolish
" let g:traces_abolish_integration = 1

" By default typing space goes to next character
" This needs to be defined before leader commands are defined
nnoremap <space> <nop>
let mapleader = "\<Space>" " map leader to space

" theme {{{
if has('termguicolors')
  set termguicolors
endif

" need this to change cursor color https://github.com/neovim/neovim/issues/12626#issuecomment-799077796
set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor
aug kitty_cursor
  au!
  au Colorscheme * set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor
aug END

function! CustomSubstrata() abort
  " highlight! link LspDiagnosticsFloatingError ErrorFloat

  hi Todo guifg=#fdcf7c guibg=NONE gui=NONE cterm=NONE
  hi SpecialComment guifg=#fdcf7c guibg=NONE gui=NONE cterm=NONE

  hi CursorLineNr guifg=#6c6f82 guibg=NONE gui=NONE cterm=NONE
  " https://stackoverflow.com/a/35681864/7683365
  hi StatusLineNC guifg=#5b5f71 guibg=#20222d gui=NONE cterm=NONE
  hi StatusLine guifg=#6c6f82 guibg=#20222d gui=NONE cterm=NONE
  hi Cursor guifg=#191c25 guibg=#cbe3e7 ctermfg=red ctermbg=yellow
  " TODO add warning squiggle, remove ~ after EOF


  " hi LspDiagnosticsDefaultHint guifg=LightGrey
  hi LspDiagnosticsDefaultError guifg=#f17a7a
  hi LspDiagnosticsDefaultWarning guifg=#d6a255
  " hi LspDiagnosticsDefaultInformation guifg=LightBlue

  " hi ErrorText cterm=underline gui=undercurl guisp=#232323
  " hi link LspDiagnosticsUnderlineError ErrorText
  " hi LspDiagnosticsUnderlineWarning cterm=underline gui=undercurl guisp=Orange
  " hi LspDiagnosticsUnderlineInformation cterm=underline gui=undercurl guisp=LightBlue
  " hi LspDiagnosticsUnderlineHint cterm=underline gui=undercurl guisp=LightGrey

  lua vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "🚧", numhl = ""})
  lua vim.fn.sign_define("LspDiagnosticsSignError", {text = "🔥", numhl = ""})
  lua vim.fn.sign_define("LspDiagnosticsSignHint", {text = "🌿", numhl = ""})
  " lua vim.fn.sign_define("LspDiagnosticsSignError", {text = "•", texthl = "LspDiagnosticsDefaultError"})

  highlight LspReference guifg=#191c25 guibg=#8296b0 guisp=NONE gui=NONE cterm=NONE ctermfg=NONE ctermbg=59
  highlight link LspReferenceText LspReference
  highlight link LspReferenceRead LspReference
  highlight link LspReferenceWrite LspReference
endfunction

augroup MyColors
  autocmd!
  autocmd ColorScheme substrata call CustomSubstrata()
augroup END

" theme
" let g:embark_terminal_italics = 1
" colorscheme embark
let g:substrata_italic_functions = 0
colorscheme substrata
" }}}

" forgive me father i've sinned
set mouse=nv
" from
" https://www.reddit.com/r/vim/comments/nlvrhd/vimmers_of_reddit_whats_an_unknown_tip_that_has/gzludfw/
" to not to displace cursor position when clicking back on window
autocmd FocusGained * call timer_start(100, { tid -> execute('set mouse+=a')})
autocmd FocusLost * set mouse=

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

if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif
" TODO: in telescope use grep instead of vimgrep and rg, in above code show
" hidden files but exclude .git repo, make visual star search to use grep
" instead of vimgrep, also see https://github.com/romainl/vim-qf

set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*,*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls,*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*/dist/*,*/build/*,.idea/**,*DS_Store*,*/coverage/*,*/.git/*,*/package-lock.json

" TODO: put them in a directory other than nvimfiles
" lua require("init")
" luafile ~/nvimfiles/lsp-saga.lua
luafile ~/nvimfiles/lsp.lua
" luafile ~/nvimfiles/efm-for-format.lua
" luafile ~/nvimfiles/eslint-daemon.lua
" luafile ~/nvimfiles/lsp-eslint.lua
luafile ~/nvimfiles/tag.lua
luafile ~/nvimfiles/format.lua
lua require("mine.telescope")
" luafile ~/nvimfiles/lightbulb.lua
source ~/nvimfiles/compe.vim
luafile ~/nvimfiles/compe-bracket.lua
source ~/nvimfiles/intelligent-keybindings.vim
source ~/nvimfiles/lightline.vim
" source ~/nvimfiles/startify.vim
" luafile ~/nvimfiles/color-highlight.lua
luafile ~/nvimfiles/treesitter.lua
luafile ~/nvimfiles/lir.lua
luafile ~/nvimfiles/which_key.lua
luafile ~/nvimfiles/comment.lua

" source ~/nvimfiles/disabled.vim

" https://vim.fandom.com/wiki/Folding and :h fold-commands
set foldlevel=21
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" used this to highlight current word https://vi.stackexchange.com/a/2770
" commented as it doesn't updates [7/21] match count at bottom right
" source ~/nvimfiles/highlight-word.vim
" ^ TODO https://gist.github.com/romainl/379904f91fa40533175dfaec4c833f2f

nnoremap - <cmd>execute "try \n edit %:h \n catch \n edit . \n endtry"<cr>

let g:Hexokinase_highlighters = ['backgroundfull']

" substitute word under cursor in the line
" TODO add operator mode substitution
" nnoremap <leader>SS :S/<c-r>=tolower(expand("<cword>"))<cr>//g<left><left>

" For easy command access and to not to lose `;` functionality
" nnoremap ; :
" nnoremap : ;
" vnoremap ; :
" vnoremap : ;
" ^ I noticed that few Vim plugins which use `feedkeys` with `:` passed are trying to
" use command line. While using `:` in nmap works fine it doesn't for
" `feedkeys`. I don't use `,` to go back w/ f/t/F/T movements anyway.
nnoremap ; :
nnoremap , ;
vnoremap ; :
vnoremap , ;

" ctrl+s to save
inoremap <c-s> <esc><cmd>w<cr>
" to keep yourself in insert mode, use inoremap <c-s> <c-o><cmd>w<cr>
nnoremap <c-s> <esc><cmd>w<cr>
vnoremap <c-s> <esc><cmd>w<cr>gv

" relative line numbers
set number relativenumber

" number of lines to see below and above of cursor
set scrolloff=3
" see https://github.com/drzel/vim-scrolloff-fraction
" ^ excluding filetypes didn't worked out for me
augroup change_ft_scrolloff
  autocmd!
  autocmd FileType Mundo* setlocal scrolloff=0
  " this didn't worked out:
  " autocmd FileType Mundo* <buffer> setlocal scrolloff=3
  " scrolloff for `qf` is in after/ftplugin
augroup END

" use q to quickly escape out from help
autocmd Filetype help nnoremap <buffer> q :q<cr>

" For a wrapped line which is lets say wrapped to 2 lines, vim will still
" treat it as a single line and so will jump over that 2nd line when navigated
" using j or k. This fixes that.
" nmap k gk
" nmap j gj

" there is `gq<text object>` but I still am not convinced to remove these
" mappings in favour of `gq` command as it modifies lines just like `fmt`
" command does.
nnoremap <expr> j v:count == 0 ? 'gj' : "\<Esc>".v:count.'j'
nnoremap <expr> k v:count == 0 ? 'gk' : "\<Esc>".v:count.'k'

" https://ddrscott.github.io/blog/2016/sidescroll/
" oddly, nvim or polygot set wrap but not linebreak
" set wrap
" set linebreak
set nowrap
" set sidescroll=1 // I didn't liked horizontal scrolling in VS Code and this
" extension will exactly emulate that behaviour. Let me stick to Vim defaults
" for sometime.
" ^ for horizontal scrolling refer to this
" https://stackoverflow.com/questions/5989739/horizontal-navigation-in-long-lines

" https://www.reddit.com/r/vim/comments/4hoa6e/what_do_you_use_for_your_listchars/
" ^ this has highlighting tokens mentioned too
" set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
" set list
set list listchars=tab:ᐅ\ ,trail:·,extends:>,precedes:<,nbsp:~

" quick tip: rather than pressing enter after search and using n and N to
" navigate, you can use <c-g> and <c-t>. It won't give you match count, it
" won't highlight all matches, sure, but it still feels faster getting to the
" target. It also doesn't store jumps in jumplist.
" Another good thing about this^ is that you can interactively delete stuff,
" for eg. d/}<c-g><c-g><cr>
" One more tip, use \V at start of query to issue a non-magic search
" so you can search `.` without escaping it for example. For more, see :help \v.
nnoremap <leader>/ /\V
nnoremap <leader>? ?\V
" ^ or just use sneak/hop

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

" Rooter
let g:rooter_patterns = ['src', '.git', 'Makefile', 'node_modules']

" Copies active file path to default/system clipboard register
" If you are tabbing between a file in project and an empty file, absolute
" path is mistakingly yanked. So first time yank is send to null register
" (otherwise known as black hole register), we tab away and then tab
" back to the active file and finally we copy its relative path.
" To copy absolute path or filename, see https://stackoverflow.com/q/916875 or
" even better https://stackoverflow.com/questions/27448157/copy-only-filename-without-extension-to-system-clipboard
" Further reading-> :help filename-modifiers
nnoremap <leader>cp <cmd>let @" = expand("%")<cr>
nnoremap <leader>Cp <cmd>let @+ = expand("%")<cr>

nnoremap <leader>cn <cmd>let @" = expand("%:t")<cr>
nnoremap <leader>Cn <cmd>let @+ = expand("%:t")<cr>

" Swaps block of code, respecting indentation of blocks in which it is swapped
" to (esp. useful in visual line mode)
" move line blocks up or down
" more at https://old.reddit.com/r/vim/comments/na7qmm/help_how_to_move_lines_like_in_vscode/gxs37rh/
" nnoremap <silent><c-j> :m .+1<CR>==
" nnoremap <silent><c-k> :m .-2<CR>==
vnoremap <silent><c-j> :m '>+1<cr>gv=gv
vnoremap <silent><c-k> :m '<-2<cr>gv=gv

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

  let &undodir=target_path
  set undofile
endif

" Quick scope (horizontal navigation using find) token colors
" highlight QuickScopePrimary guifg='#6bdeba' gui=underline ctermfg=81
highlight QuickScopePrimary guifg='#6ade93' gui=underline ctermfg=81
highlight QuickScopeSecondary guifg='#ffa9d5' gui=underline ctermfg=81

" create new file relattive to current file, use `:e ` to create one wrt root
" of project. We are using <c-z> to simulate tab, see
" https://stackoverflow.com/questions/32513835/create-vim-map-that-executes-tab-autocomplete
" Also, we are using : over <cmd> so vim doesn't ask us to append <cr> at the
" end. More separators here ->
" http://vimdoc.sourceforge.net/htmldoc/cmdline.html#filename-modifiers
set wildcharm=<c-z>
" space and backspace are added to prevent autosuggest from showing parent folder
" suggestions
nnoremap <leader>n :e %:.:h<c-z><space><bs>
" nnoremap <leader>n :e %:.:h<c-z>

nnoremap <leader>fd <cmd>Telescope open_dir<cr>

" vim abolish substitute
" vnoremap ss :S///g<left><left><left>

" reselect the text that was just pasted, and indent it
" V = visually select lines, `] = till end of paste, = = indent
" useful for formatting system clipboard contents
nnoremap <leader>= V`]
" `] will go to end of last inserted/pasted text and
" `[ will go to the start of it
" might be relevant https://stackoverflow.com/a/7087202/7683365
" an alternative mapping could be nnoremap =p V`]=

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

" https://stackoverflow.com/a/3879737/7683365
fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

call SetupCommandAlias("nt","tabnew")
call SetupCommandAlias("rg","Grep")

" stop rooter plugin to echo on start in msgs
" let g:rooter_silent_chdir = 1
" ^ commented as not using startify anymore

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stabs call Stabs()
function! Stabs()
  let l:tabstop = 1 * input('setlocal tabstop = softtabstop = shiftwidth = ')
  if l:tabstop > 0
    let &l:sts = l:tabstop
    let &l:ts = l:tabstop
    let &l:sw = l:tabstop
  endif
  echo "\r"
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
" ^ FIXME logs on the same line on which it has taken input

" commenting out this and the one below it
" remember folds, seems like symlinks don't have a filename, see how it can be
" fixed
" autocmd BufWinLeave *.* silent! mkview
" autocmd BufWinEnter *.* silent! loadview
" disabled as i lose cursor position when i use `:e`. To reproduce:
" 1. close vim with a file opened in changed position
" 2. open vim, you'll see the position is restored
" 3. move to a new positon and press `:e`. This will revert back to old
" position
" TODO ^ this needs to be file level (local) than anything so it can be used
" for init.vim and not for anything else for example

" return to last cursor position on file open by using `"` mark
" taken from vim user manual, also see https://stackoverflow.com/a/40992753/7683365
" also see https://stackoverflow.com/questions/8854371/vim-how-to-restore-the-cursors-logical-and-physical-positions
" and https://github.com/farmergreg/vim-lastplace
" and https://github.com/zhimsel/vim-stay
" this doesn't return to last position wrt window (that "also see" answer can
" help) but I don't want that feature either
" au BufReadPost *
"     \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
"     \ |   exe "normal! g`\""
"     \ | endif


" ain't nobody got time to write `gcc` to comment one line, I'll use ctrl+/ instead
" https://github.com/JoosepAlviste/nvim-ts-context-commentstring/issues/5#issuecomment-814175077
function! s:ConfigCommentary() abort
  function! s:CommentaryImplExpr(a)
    try
      lua require('ts_context_commentstring.internal').update_commentstring()
    catch
      " silenty suppress the error if treesitter doesn't exist for the language
    endtry
    if a:a == 1
      return "\<Plug>Commentary"
    else
      return "\<Plug>CommentaryLine"
    endif
  endfunction

  xmap <expr><C-_> <sid>CommentaryImplExpr(1)
  nmap <expr><C-_> <sid>CommentaryImplExpr(0)
endfunction

call s:ConfigCommentary()

" @@ repeats last macro, @: repeats last command
" nnoremap Q @@

let g:context_enabled = 0
let g:context_add_mappings = 0
let g:context_max_height = 7

function! ShowContextWithLeastDisturbance()
  let curr_line_from_top = winline()
  if curr_line_from_top <= g:context_max_height + 2
    let calc_shift = g:context_max_height - curr_line_from_top + 3
    exe "sil norm!" . calc_shift ."\<c-y>"
  endif
  ContextPeek
endfunction

" s: show, g: goto, i: intelligent code related actions given by LSP and
" friends, f: find
nnoremap <silent><leader>sc :call ShowContextWithLeastDisturbance()<cr>

" better diffing
set diffopt+=algorithm:histogram,indent-heuristic,vertical
" haven't tried this:
" set diffopt+=iwhite
" you can set context too, see https://unix.stackexchange.com/a/290501
" more https://unix.stackexchange.com/a/352204

let g:localvimrc_persistent = 1

" indent file without leaving cursor pos
" from https://stackoverflow.com/a/20110045/7683365
nnoremap g= :let b:PlugView=winsaveview()<CR>gg=G:call winrestview(b:PlugView) <CR>:echo "file indented"<CR>

" for file type ~/.vim/after/ftplugin/html.vim as `setlocal shiftwidth=2`
" other way could be: autocmd BufRead,BufNewFile   *.c,*.h,*.java set noic cin noexpandtab
" TODO doesn't sets indentation
augroup filetype_based_indentation
  autocmd!
  autocmd VimEnter * set tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType python setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
augroup END

" color highlight group of a token under the cursor
function! SynGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" there are ways to trim whitespace on save but i'm not doing it for now
" https://stackoverflow.com/a/1618401/7683365

" hey `:h map-which-keys` said it (we have alt key and fn key too but then we
" have leader too if we want to do this only)
" nnoremap <silent>, <cmd>ToggleAlternate<CR>

" disabled as it interferes in session, eg || TermA | FileB || are windows of
" of a tab and you are one FileB, when you close and reopen vim, FileB will
" have focus but you'll be dropped into insert mode
" augroup open_term_in_insert_mode
"   autocmd!
"   autocmd TermOpen term://* startinsert
" augroup END

set noswapfile

" what is the point of saving blank (empty) windows?
set sessionoptions-=blank

" " for taboo.vim
" set sessionoptions+=globals

" from https://github.com/cocopon/vaffle.vim/issues/56#issuecomment-701888156
let g:projectionist_ignore_vaffle = 1

" https://vi.stackexchange.com/a/9439
" also handle ctlr-c and esc key

" goto file and create it if is not present
" from https://stackoverflow.com/a/29068665/7683365
function! Gf()
  let l:filepath = expand('<cfile>')

  " check if it is a URL, if it is then load it up
  if l:filepath[0:len('https://')-1] ==# 'https://' || l:filepath[0:len('http://')-1] ==# 'http://'
    " from autoload/fugitive.vim s:BrowserOpen function
    if !exists('g:loaded_netrw')
      runtime! autoload/netrw.vim
    endif

    if exists('*netrw#BrowseX')
      call netrw#BrowseX(l:filepath, 0)
    endif

    if has('clipboard')
      let @+ = l:filepath
      echo 'Opening URL in browser, it has been copied to clipboard too.'
    endif

    return
  endif

  try
    exec "normal! gf"
  catch /E447/
    " if I'm going into edit mode, I'm not technically creating it
    echo "File doesn't exist, `edit` it anyway? (y/N) "
    let l:confirm = nr2char(getchar())

    if empty(l:confirm) || l:confirm !=? 'y'
      " skipping `Press Enter or command to continue` prompt by feeding a key
      " update: doing this w/ this way
      exec "norm :echo 'Cancelled'\<cr>"
      return
    endif

    exec "norm :echo ''\<cr>"

    " from
    " https://github.com/zlksnk/vaffle.vim/commit/099cf689e25f525098415a517fff0209080dd0c9#diff-447d11dad6ddd636f8cb5436d1984ea4b33048feab8d0f5e3e3e20ea01e6cdeaR33
    if l:filepath[0:len('./')-1] ==# './'
      let l:fullpath = expand("%:h") . l:filepath[1:]
      exec 'edit ' . l:fullpath
    else
      edit <cfile>
    endif
  endtry
endfunction
noremap <silent>gf :call Gf()<CR>

" from unimpared.vim
function! s:BlankUp(count) abort
  put!=repeat(nr2char(10), a:count)
  ']+1
endfunction

function! s:BlankDown(count) abort
  put =repeat(nr2char(10), a:count)
  '[-1
endfunction

nnoremap [o <cmd>call <sid>BlankUp(v:count1)<cr>
nnoremap ]o <cmd>call <sid>BlankDown(v:count1)<cr>

" https://superuser.com/a/581669
" and `ga` in normal mode to get char info
function! s:SpaceBefore(count) abort
  " https://vi.stackexchange.com/a/12480
  call feedkeys(a:count . '"=nr2char(32)' . "\<CR>" . 'Pl')
  " https://stackoverflow.com/a/47789099/7683365
  call feedkeys(":echo\<cr>")
endfunction

function! s:SpaceAfter(count) abort
  call feedkeys(a:count . '"=nr2char(32)' . "\<CR>" . 'p`[h')
  call feedkeys(":echo\<cr>")
endfunction

nnoremap [<space> <cmd>call <sid>SpaceBefore(v:count1)<cr>
nnoremap ]<space> <cmd>call <sid>SpaceAfter(v:count1)<cr>

" you can also use a combination of `tabedit %` with `tabclose` or `q`
" taken from https://stackoverflow.com/a/60639802/7683365
function! ToggleZoom(zoom)
  if exists("t:restore_zoom") && (a:zoom == v:true || t:restore_zoom.win != winnr())
    exec t:restore_zoom.cmd
    unlet t:restore_zoom
  elseif a:zoom
    let t:restore_zoom = { 'win': winnr(), 'cmd': winrestcmd() }
    exec "normal \<C-W>\|\<C-W>_"
  endif
endfunction

augroup restorezoom
  au WinEnter * silent! :call ToggleZoom(v:false)
augroup END
nnoremap <silent> <Leader>+ :call ToggleZoom(v:true)<CR>

" don't start searching from top when `n` is pressed on last match, I'll do
" `ggn` if I need it
set nowrapscan

" from https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
" and w/ the help of sjl/clam.vim
function! Redir(cmd, rng, start, end)
  for win in range(1, winnr('$'))
    if getwinvar(win, 'scratch')
      execute win . 'windo close'
    endif
  endfor
  if a:cmd =~ '^!'
    let cmd = a:cmd =~' %'
          \ ? matchstr(substitute(a:cmd, ' %', ' ' . expand('%:p'), ''), '^!\zs.*')
          \ : matchstr(a:cmd, '^!\zs.*')
    if a:rng == 0
      let output = systemlist(cmd)
    else
      let lines = getline(a:start, a:end)
      let stdin = join(lines, "\n") . "\n"
      let output = system(cmd, stdin)
    endif
    let output = split(output, "\n")
  else
    redir => output
    execute a:cmd
    redir END
    let output = split(output, "\n")
  endif
  vnew
  let w:scratch = 1
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile
  call setline(1, output)
endfunction

command! -nargs=1 -complete=command -bar -range Redir silent call Redir(<q-args>, <range>, <line1>, <line2>)
" command! RedirToCurrentBuffer silent let w:scratch = 1

source ~/nvimfiles/blame.vim

let b:lion_squeeze_spaces = 1

" these, changing j/k behaviour, removing `s` in favour of surround plugin
" and swapping `:` with `;` are the only ones that I'll use which override
" true vim behaviour
nnoremap 0 ^
nnoremap ^ 0
vnoremap 0 ^
vnoremap ^ 0
onoremap 0 ^
onoremap ^ 0
nnoremap g0 g^
nnoremap g^ g0
vnoremap g0 g^
vnoremap g^ g0
onoremap g0 g^
onoremap g^ g0

function! <SID>TrimTrailingWhitespaces()
  if !&binary && &filetype != 'diff'
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
  endif
endfun
command! TrimTrailingWhitespaces
      \ call s:TrimTrailingWhitespaces()
" autocmd FileType c,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>TrimTrailingWhitespaces()

let g:python3_host_prog = "$HOME/miniconda3/bin/python3"

" from https://gist.github.com/PeterRincker/69b536f303f648cc21ec2ff2282f8c4a
function! Diff(mods, spec)
  let l:truecwd = getcwd()
  let l:root_identifiers = g:rooter_patterns
  if len(a:spec)
    let g:rooter_patterns = ['.git']
  endif

  let mods = a:mods
  if !len(mods) && &diffopt =~ 'vertical'
    let mods = 'vertical'
  endif
  execute 'topleft ' . mods . ' new'
  setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
  let cmd = "++edit #"

  if len(a:spec)
    let cmd = "!git -C " . shellescape(fnamemodify(finddir('.git', '.;'), ':p:h:h')) . " show " . a:spec . ":#"
  endif

  execute "read " . cmd
  silent 0d_
  let &filetype = getbufvar('#', '&filetype')
  augroup Diff
    autocmd!
    autocmd BufWipeout <buffer> diffoff!
  augroup END
  diffthis
  " nnoremap <buffer>q <C-W>c

  wincmd p
  diffthis

  wincmd p

  " FIXME this lcd isn't persisting if I leave scratch window and come back, fix it
  " execute 'lcd ' . l:truecwd
  let g:rooter_patterns = l:root_identifiers
endfunction
command! -nargs=? Diff call Diff(<q-mods>, <q-args>)

let g:undotree_SetFocusWhenToggle = 1

" goto location
" for separate use 33G or :33<cr> to go to line and 14| to go to column
nnoremap gl :call cursor()<left>

" TODO add in lightline query name, see :chistory and match its count and qflist
" count (check if filtered qflist is new or polluted the current) to show
" modified/filtered
let g:qf_mapping_ack_style = 1
let g:bettergrep_no_mappings = 1
let g:bettergrep_no_abbrev = 1

lua << EOF
require('bqf').setup({
  preview = {
    auto_preview = false,
  },
  func_map = {
    stogglebuf = "gb",
    openc = "O",
    pscrollup = "<nop>",
    pscrolldown = "<nop>",
  }
})
EOF

function! s:CheckJuggle()
  if exists('w:juggle_alt')
    if bufnr() != w:juggle_alt
      let w:juggle_to = w:juggle_alt
    endif
  endif
  let w:juggle_alt = bufnr('#')
endfun

aug check_juggle
  au!
  au BufWinEnter  *.* call <sid>CheckJuggle()
aug END

function! s:Juggle()
  if exists('w:juggle_to')
    e#
    execute 'buffer ' . w:juggle_to
  endif
endfun
command! Juggle
      \ call s:Juggle()

" disables auto-trigger feature of ultisnips https://github.com/SirVer/ultisnips/issues/1239#issuecomment-640841645
if has('nvim')
  au VimEnter * if exists('#UltiSnips_AutoTrigger')
        \ |     exe 'au! UltiSnips_AutoTrigger'
        \ |     aug! UltiSnips_AutoTrigger
        \ | endif
endif

function! SetVisualBlock(start, end)
  " Trigger visual block mode
  execute "norm! \<C-v>\<Esc>"

  " Set the marks
  call setpos("'<", [ 0, a:start[0], a:start[1] ])
  call setpos("'>", [ 0, a:end[0], a:end[1] ])

  " Select based on the marks
  norm! gv
endfunction
" --- Calling the function
" call SetVisualBlock([24, 6], [22, 3])

command! UltiSnipsLookup
      \ Telescope ultisnips ultisnips

command! FormatUsingLsp
      \ lua vim.lsp.buf.formatting()

" http://www.akhatib.com/format-json-files-in-vim/
function! FormatJson()
  set ft=json
  let b:pre_fmt_view = winsaveview()
  %!python -m json.tool --indent=2
  call winrestview(b:pre_fmt_view)
  " call feedkeys('g=')
endfun
command! FormatJson
      \ call FormatJson()

" {{{ show highlight on word
" from https://vim.fandom.com/wiki/Highlight_current_word_to_find_cursor
function! HighlightNearCursor()
  if !exists("s:highlightcursor")
    match Search /\k*\%#\k*/
    let s:highlightcursor=1
  else
    match None
    unlet s:highlightcursor
  endif
endfunction

nnoremap <leader>h <cmd>call HighlightNearCursor()<cr>

function! ClearHighlightNearCursor()
  if exists("s:highlightcursor")
    match None
    unlet s:highlightcursor
  endif
endfunction

augroup highlight_near_cursor
  autocmd!
  " taken from vim sneak plugin
  autocmd CursorMoved * autocmd highlight_near_cursor CursorMoved * call ClearHighlightNearCursor()
augroup END
" }}}

" {{{ show highlight on word
" set cursorline
" from https://vi.stackexchange.com/a/10291
function! HighlightLine()
  if !exists("s:highlightline")
    setlocal cursorline
    let s:highlightline=1
  else
    setlocal nocursorline
    unlet s:highlightline
  endif
endfunction

nnoremap <leader>H <cmd>call HighlightLine()<cr>

function! ClearHighlightLine()
  if exists("s:highlightline")
    setlocal nocursorline
    unlet s:highlightline
  endif
endfunction

augroup highlight_line
  autocmd!
  autocmd CursorMoved * autocmd highlight_line CursorMoved * call ClearHighlightLine()
augroup END
" }}}

" {{{ show highlight on symbol
function! HighlightSymbol()
  if !exists("s:highlightsymbol")
    let s:highlightsymbol=1
    lua vim.lsp.buf.document_highlight()
  else
    unlet s:highlightsymbol
    lua vim.lsp.buf.clear_references()
  endif
endfunction

nnoremap <leader>th <cmd>call HighlightSymbol()<cr>
" }}}

" -- wrap line after 80 chars and color 81st column
" set textwidth=80
" set colorcolumn=+1
" -- alternatively, turn chars after 80 red (error color)
" au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)

" use vim-surround mapping instead to not to shadow sentence based operations
" like `cis` (change inner sentence)
let g:operator_sandwich_no_default_key_mappings = 1
source ~/nvimfiles/surround.vim

" TODO ivy!! https://github.com/nvim-telescope/telescope.nvim/pull/771
" https://github.com/nvim-telescope/telescope.nvim/issues/765

" " Start interactive EasyAlign in visual mode (e.g. vipga)
" xmap gb <Plug>(EasyAlign)
" " Start interactive EasyAlign for a motion/text object (e.g. gaip)
" nmap gb <Plug>(EasyAlign)

" let g:easy_align_delimiters = {
"       \   '/': {
"       \       'pattern': '\/\/',
"       \   },
"       \ }

nmap <Plug>SpeedDatingFallbackUp   <Plug>(CtrlXA-CtrlA)
nmap <Plug>SpeedDatingFallbackDown <Plug>(CtrlXA-CtrlX)

command! -nargs=1 -complete=command Stay call <SID>Stay(<f-args>)
function! s:Stay(cmd) range
  let view = winsaveview()
  execute a:cmd
  call winrestview(view)
endfunction

" ^^ checklist
" augroup MappyTime
"   autocmd!
"   autocmd FileType markdown nnoremap <buffer> <silent> <leader>x :Stay keeppatterns s/^\s*-\s*\[\zs.\ze\]/\=get({' ': 'x', 'x': ' '}, submatch(0), ' ')/e<cr>
"     \| nnoremap <buffer> <silent> <leader>cc :Stay keeppatterns s/^\s*-\s*\[\zs.\ze\]/\=get({' ': '-', '-': 'x', 'x': ' '}, submatch(0), ' ')/e<cr>
"     \| nnoremap <buffer> <silent> <leader>cl :s/^/- [ ] <cr><bar><cmd>noh<cr>
"     \| vnoremap <buffer> <silent> <leader>cl :s/^/- [ ] <cr><bar><cmd>noh<cr>
" augroup END

" Grep usage ->
" :Grep statsapi -g *test*
" :Grep utils/helpers
" :Grep 'fetch\('
" :Grep fetch -g '!*lock*' -g '!*worker*'

" Highlight it is the only key shown
highlight HopNextKey  guifg=#6ade93 gui=bold ctermfg=198 cterm=bold,underline
" Highlight used for the first key in a sequence.
highlight HopNextKey1 guifg=#ffa9d5 gui=bold,underline ctermfg=45 cterm=bold,underline
" Highlight used for the second and remaining keys in a sequence.
highlight HopNextKey2 guifg=#da68a2 ctermfg=33
" Highlight used for the unmatched part of the buffer.
highlight HopUnmatched guifg=#666666 ctermfg=242

function! s:PutModifiedFilesInArglist()
  arglocal
  silent! argdelete *
  bufdo if &modified | argadd | endif
  first
endfunction

command! PutModifiedFilesInArglist
      \ call s:PutModifiedFilesInArglist()

" unimpared like mapping for arglist
nnoremap [a <cmd>prev<cr>
nnoremap ]a <cmd>next<cr>
nnoremap [A <cmd>first<cr>
nnoremap ]A <cmd>last<cr>

" unimpared like mapping for location list
nnoremap [l <cmd>lprev<cr>
nnoremap ]l <cmd>lnext<cr>
nnoremap [L <cmd>lfirst<cr>
nnoremap ]L <cmd>llast<cr>

" unimpared like mapping for quickfix list
nnoremap [q <cmd>cprev<cr>
nnoremap ]q <cmd>cnext<cr>
nnoremap [Q <cmd>cfirst<cr>
nnoremap ]Q <cmd>clast<cr>

" original jumplist behaviour is not the one I wanted
" https://vi.stackexchange.com/questions/18344/how-to-change-jumplist-behavior
" also jumplist will record numbered jumps like 20G but record jumps for 7j
" ^ TODO this can be solved using any one of these:
" https://medium.com/breathe-publication/understanding-vims-jump-list-7e1bfc72cdf0
" https://vi.stackexchange.com/questions/7582/how-to-add-numbered-movement-to-the-jump-list
" https://stackoverflow.com/a/29746735/7683365
" ^ though i think of against it (eg. I could use kkk over 3k)
set jumpoptions+=stack
" also see keepjumps command in help, useful in your scripts
" and changelist for general movements

" search for a term occurence and store it in a variable so it can be retrived
" later to buffer using put command
" :let t = [] | g/search_term/call add(t, line('.') . ' ' . getline('.'))
" :pu=t
" Update: using `:g=term-to-search` will do exactly this

" TODO
let g:tinykeymaps_default = []
let g:tinykeymap#conflict = 1
" submode can be combined with which-key for help instead of F1 command
" https://github.com/machakann/vim-swap also has `gs` subcommand

" don't move cursor to first char when using operator mode (creating comments or using surround.vim) {{{
" from https://vimways.org/2019/making-things-flow/
" this as it also affects paste if you are using vim-yoink for eg. to override `p` behaviour
" also this interferes with vim-exchange
" function! OpfuncSteady()
"   if !empty(&operatorfunc)
"     call winrestview(w:opfuncview)
"     unlet w:opfuncview
"     noautocmd set operatorfunc=
"   endif
" endfunction

" augroup OpfuncSteady
"   autocmd!
"   autocmd OptionSet operatorfunc let w:opfuncview = winsaveview()
"   autocmd CursorMoved * call OpfuncSteady()
" augroup END
" }}}

" don't move my cursor to first char of yanked text {{{
" from https://www.reddit.com/r/vim/comments/ekgy47/question_how_to_keep_cursor_position_on_yank/fddnfl3/
augroup yank_restore_cursor
  autocmd!
  autocmd VimEnter,CursorMoved *
    \ let s:cursor = getpos('.')
  autocmd TextYankPost *
    \ if v:event.operator ==? 'y' |
    \   call setpos('.', s:cursor) |
    \ endif
augroup END
" }}}

nmap <leader>r <plug>(SubversiveSubstitute)
nmap <leader>rr <plug>(SubversiveSubstituteLine)
nmap <leader>R <plug>(SubversiveSubstituteToEndOfLine)

nmap \ <plug>(SubversiveSubstituteRange)
xmap \ <plug>(SubversiveSubstituteRange)
nmap \\ <plug>(SubversiveSubstituteWordRange)
" commenting as it interferes with `c` command in visual mode
" nmap c\ <plug>(SubversiveSubstituteRangeConfirm)
" xmap c\ <plug>(SubversiveSubstituteRangeConfirm)
" nmap c\\ <plug>(SubversiveSubstituteWordRangeConfirm)

let g:miniyank_maxitems = 100

" exit fzf using <c-c> or <c-q> https://github.com/junegunn/fzf.vim/issues/544
" from https://github.com/junegunn/fzf/issues/1393#issuecomment-426576577
autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

" from https://github.com/bfredl/nvim-miniyank/issues/19
function! s:fzf_miniyank(put_before, fullscreen) abort
  function! Sink(opt, line) abort
    let l:key = substitute(a:line, ' .*', '', '')
    if empty(a:line) | return | endif
    let l:yanks = miniyank#read()[l:key]
    call miniyank#drop(l:yanks, a:opt)
  endfunction

  let l:put_action = a:put_before ? 'P' : 'p'
  let l:name = a:put_before ? 'YanksBefore' : 'YanksAfter'
  let l:spec = {}
  let l:spec['source'] = map(miniyank#read(), {k,v -> k.' '.join(v[0], '\n')})
  let l:spec['sink'] = {val -> Sink(l:put_action, val)}
  let l:spec['options'] = '--no-sort --prompt="Yanks-'.l:put_action.'> "'
  call fzf#run(fzf#wrap(l:name, l:spec, a:fullscreen))
endfunction

command! -bang YanksBefore call s:fzf_miniyank(1, <bang>0)
command! -bang YanksAfter call s:fzf_miniyank(0, <bang>0)

map <A-p> :YanksAfter<CR>
map <A-P> :YanksBefore<CR>

" slightly modified vimtip mentioned in https://github.com/inkarkat/vim-UnconditionalPaste
function! PasteJointCharacterwise(regname, pastecmd)
  let reg_type = getregtype(a:regname)
  call setreg(a:regname, '', "ac")
  exe 'normal "'.a:regname . a:pastecmd
  call setreg(a:regname, '', "a".reg_type)
  exe 'normal `[v`]gJ'
endfunction
nmap <silent><Leader>ip :call PasteJointCharacterwise(v:register, "p")<CR>
nmap <silent><Leader>iP :call PasteJointCharacterwise(v:register, "P")<CR>
vmap <silent><Leader>ip :call PasteJointCharacterwise(v:register, "p")<CR>
vmap <silent><Leader>iP :call PasteJointCharacterwise(v:register, "P")<CR>


" mark your current pos so you can come back when doing 3j motion
" for example
nnoremap <silent><leader>m <cmd>execute "normal " . getcurpos()[1] . "G" . getcurpos()[2] . "\|"<cr>

" set tw=0 wrap linebreak

" https://vi.stackexchange.com/a/8453
nnoremap <leader>fl <cmd>ls<cr>:b<space>
nnoremap <leader>fm :<C-u>marks<CR>:normal! `
nnoremap <leader>fu :undolist<CR>:u<Space>
nnoremap <leader>ft :tags<CR>:pop<Home><c-r>=gettagstack().length<cr>

" Redir g=search_term

" TODO wrap errrors correctly:
" https://stackoverflow.com/questions/32031473/lua-line-wrapping-excluding-certain-characters
" https://vi.stackexchange.com/a/4930

command! GShowLastCmdOutput exec('e ' . g:_fugitive_last_job['file'])

" FIXME: currently, this fetches other branches with full history
" command! RepoEditShowOtherBranches exec("!git remote set-branches origin '*'")
"   \ | echo 'You need to do a fetch now to get info of other branches.'
" command! RepoEditShowFullHistoryOfCurrentBranch exec("!git fetch --unshallow")
"   \ | echo 'You might need to reopen Git UI tab/window to see the changes'
" https://stackoverflow.com/a/24107926/7683365
command! -nargs=1 RepoEditFetchOtherBranch exec('!git fetch --depth 1 origin'. ' ' . <q-args> . ':refs/remotes/origin/' . <q-args>)
  \ | echo 'Fetch done. Checkout this remote branch or create a local branch from it.'

" wrap for comments, see :h gq
nnoremap Q gq

source ~/nvimfiles/quickswitch.vim
function! s:OpenRelated(to_open, mode = v:null)
  " :r removes extension (see :h %:r)
  " removing extension two times is fine as both names `app.js` and `app.test.js` will
  " result in `app`
  let l:file_name = expand('%:t:r:r')
  call QuickSwitch(a:to_open, l:file_name, a:mode)
endfunction
command! -nargs=1 E call s:OpenRelated(<f-args>)
command! -nargs=1 EV call s:OpenRelated(<f-args>, 'vsp')
command! A call s:OpenRelated('alt')

" removes ^M sign, from https://vim.fandom.com/wiki/File_format#Converting_the_current_file
function! DosOrUnixToDos()
  update
  edit ++ff=dos
  setlocal ff=unix
  write

  update
  edit ++ff=dos
  write
endfunction
command! DosOrUnixToDos call DosOrUnixToDos()

function s:decideForSysClipboard()
  let l:char = nr2char(getchar())

  if l:char == 'r' || l:char == 'i'
    return '"+' . g:mapleader . l:char
  elseif empty(l:char)
    return ''
  else
    return '"+' . l:char
  end
endfunction

nmap <expr> <leader>v <sid>decideForSysClipboard()
vmap <expr> <leader>v <sid>decideForSysClipboard()

" Paste last explicit yank made
nmap <leader>p "0p
vmap <leader>p "0p
nmap <leader>P "0P
vmap <leader>P "0P
nmap <leader>gp "0gp
vmap <leader>gp "0gp
nmap <leader>gP "0gP
vmap <leader>gP "0gP
