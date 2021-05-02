source $HOME/.config/nvim/plugins.vim

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
" let g:embark_terminal_italics = 1
" colorscheme embark
let g:substrata_italic_functions = 0
colorscheme substrata
hi CursorLineNr guifg=#6c6f82 guibg=NONE gui=NONE cterm=NONE
" https://stackoverflow.com/a/35681864/7683365
hi StatusLineNC guifg=#5b5f71 guibg=#20222d gui=NONE cterm=NONE
hi StatusLine guifg=#6c6f82 guibg=#20222d gui=NONE cterm=NONE
" TODO add warning squiggle, remove ~ after EOF

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

" needed otherwise it'll fold on file open
" https://vim.fandom.com/wiki/All_folds_open_when_opening_a_file
" set foldlevelstart=20
" ^ seems like foldlevel does just that

" https://vim.fandom.com/wiki/Folding and :h fold-commands
set foldlevel=20
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" visual * or # search, don't consume my leader pls, I'll copy the text and
" pass it to telescope grep instead:
" nnoremap <leader>* <Nop>
" vnoremap <leader>* <Nop>
" that being said i am replacing grep (not vimgrep) with `rg` so I might revoke Nop
" keybinding above
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
luafile ~/nvimfiles/lsp.lua
" luafile ~/nvimfiles/efm-for-format.lua
luafile ~/nvimfiles/eslint-daemon.lua
" luafile ~/nvimfiles/lsp-eslint.lua
luafile ~/nvimfiles/format.lua
luafile ~/nvimfiles/telescope.lua
luafile ~/nvimfiles/lsp-saga.lua
" luafile ~/nvimfiles/lightbulb.lua
source ~/nvimfiles/compe.vim
source ~/nvimfiles/intelligent-keybindings.vim
source ~/nvimfiles/lightline.vim
" source ~/nvimfiles/startify.vim
" luafile ~/nvimfiles/color-highlight.lua
luafile ~/nvimfiles/treesitter.lua
luafile ~/nvimfiles/which_key.lua
luafile ~/nvimfiles/comment.lua

let g:Hexokinase_highlighters = ['backgroundfull']

" For easy command access and to not to lose `;` functionality
nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" ctrl+s to save
inoremap <c-s> <esc><cmd>w<cr>
" to keep yourself in insert mode, use inoremap <c-s> <c-o><cmd>w<cr>
nnoremap <c-s> <esc><cmd>w<cr>
vnoremap <c-s> <esc><cmd>w<cr>gv

" relative line numbers
set number relativenumber

" number of lines to see below and above of cursor
set scrolloff=3

" use q to quickly escape out from help
autocmd Filetype help nnoremap <buffer> q :q<cr>

" For a wrapped line which is lets say wrapped to 2 lines, vim will still
" treat it as a single line and so will jump over that 2nd line when navigated
" using j or k. This fixes that.
" nmap k gk
" nmap j gj
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
set list listchars=tab:▸\ ,trail:·,extends:>,precedes:<,nbsp:~

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

" quick tip: rather than pressing enter after search and using n and N to
" navigate, you can use <c-g> and <c-t>. It won't give you match count, it
" won't highlight all matches, sure, but it still feels faster getting to the
" target. One more tip, use \M at start of query to issue a non-magic search
" so you can search `.` without escaping it for example. For more, see :help \v.
nnoremap <leader>/ /\M
nnoremap <leader>? ?\M
" ^ or just use sneak

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
nnoremap <silent><c-j> :m .+1<CR>==
nnoremap <silent><c-k> :m .-2<CR>==
vnoremap <silent><c-j> :m '>+1<cr>gv=gv
vnoremap <silent><c-k> :m '<-2<cr>gv=gv

" Paste last explicit yank made
nnoremap <leader>v "0p
nnoremap <leader>V "0P
vnoremap <leader>v "0p
vnoremap <leader>V "0P

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

" https://stackoverflow.com/a/3879737/7683365
fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

call SetupCommandAlias("nt","tabnew")
call SetupCommandAlias("rg","GrepperRg")

" stop rooter plugin to echo on start in msgs
" let g:rooter_silent_chdir = 1
" ^ commented as not using startify anymore

" to make vim sandwich shadow vim's `s`
nmap s <Nop>
xmap s <Nop>

" sneak mode, jump to
let g:sneak#label = 1
let g:sneak#use_ic_scs = 1
" embark
" highlight SneakScope guifg=#1e1c31 guibg=#91ddff ctermfg=red ctermbg=yellow
" highlight Sneak guifg=#cbe3e7 guibg=#3e3859 ctermfg=black ctermbg=red
" substrate
highlight SneakScope guifg=#1e1c31 guibg=#cbe3e7 ctermfg=red ctermbg=yellow
highlight Sneak guifg=#cbe3e7 guibg=#212733 ctermfg=black ctermbg=red

nmap <leader>j <Plug>Sneak_s
nmap <leader>k <Plug>Sneak_S
" visual-mode
xmap <leader>j <Plug>Sneak_s
xmap <leader>k <Plug>Sneak_S
" operator-pending-mode
omap <leader>j <Plug>Sneak_s
omap <leader>k <Plug>Sneak_S

" Set tabstop, softtabstop and shiftwidth to the same value
command! -nargs=* Stabs call Stabs()
function! Stabs()
  let l:tabstop = 1 * input('set tabstop = softtabstop = shiftwidth = ')
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
" this doesn't return to last position wrt window (that "also see" answer can
" help) but I don't want that feature either
" au BufReadPost *
"     \ if line("'\"") > 1 && line("'\"") <= line("$") && &ft !~# 'commit'
"     \ |   exe "normal! g`\""
"     \ | endif

" nobody got time to write `gcc` to comment one line, I'll use ctrl+/ instead
nnoremap <c-_> <cmd>Commentary<cr>

" @@ repeats last macro, @: repeats last command
nnoremap Q @@

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

let g:vaffle_show_hidden_files = 1
let g:vaffle_force_delete = 1
nnoremap - <cmd>execute "try \n Vaffle % \n catch \n Vaffle \n endtry"<cr>

function! s:customize_vaffle_mappings() abort
  " go to project root
  nmap <buffer> -        <cmd>Vaffle<cr>
  " TODO add preview mode https://github.com/justinmk/vim-dirvish/blob/9c0dc32af9235d42715751b30cf04fa0584c1798/autoload/dirvish.vim#L241
  " and fill cmdline (present in vim vinegar)
  nmap <buffer> x        <Plug>(vaffle-toggle-current)
  vmap <buffer> x        <Plug>(vaffle-toggle-current)
  nnoremap <buffer> <leader>w <cmd>echo vaffle#buffer#extract_path_from_bufname(expand('%'))[len(getcwd())+1:]<cr>
endfunction
augroup vimrc_vaffle
  autocmd!
  autocmd FileType vaffle call s:customize_vaffle_mappings()
augroup END

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

" highlight group of a token under the cursor
function! SynGroup()
  let l:s = synID(line('.'), col('.'), 1)
  echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun

" there are ways to trim whitespace on save but i'm not doing it for now
" https://stackoverflow.com/a/1618401/7683365

" hey `:h map-which-keys` said it (we have alt key and fn key too but then we
" have leader too if we want to do this only)
nnoremap <silent>, <cmd>ToggleAlternate<CR>

" disabled as it interferes in session, eg || TermA | FileB || are windows of
" of a tab and you are one FileB, when you close and reopen vim, FileB will
" have focus but you'll be dropped into insert mode
" augroup open_term_in_insert_mode
"   autocmd!
"   autocmd TermOpen term://* startinsert
" augroup END

set noswapfile

set sessionoptions=buffers

" from https://github.com/cocopon/vaffle.vim/issues/56#issuecomment-701888156
let g:projectionist_ignore_vaffle = 1

" goto file and create it if is not present
" from https://stackoverflow.com/a/29068665/7683365
function! Gf()
  try
    exec "normal! gf"
  catch /E447/
    " if I'm going into edit mode, I'm not technically creating it
    let confirm = input("File doesn't exist. Create it? (y/N) ")
    echo "\n"
    if empty(confirm) || confirm !=? 'y'
      echo 'Cancelled.'
      return
    endif

    " echohl WarningMsg
    " echo "this file doesn't exist on disk"
    " echohl None

    " skipping `Press Enter or command to continue` prompt by feeding a key
    call feedkeys(" ")
    edit <cfile>
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

nnoremap [<space> <cmd>call <sid>BlankUp(v:count1)<cr>
nnoremap ]<space> <cmd>call <sid>BlankDown(v:count1)<cr>

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

lua require('numb').setup()

" don't start searching from top when `n` is pressed on last match, I'll do
" `ggn` if I need it
set nowrapscan

" from https://gist.github.com/romainl/eae0a260ab9c135390c30cd370c20cd7
" FIXME escapes don't work, console.log('fs\ndf') needs to be
" console.log('fs\\\ndf')
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
      let joined_lines = join(getline(a:start, a:end), '\n')
      let cleaned_lines = substitute(shellescape(joined_lines), "'\\\\''", "\\\\'", 'g')
      " modfied for fish
      let output = systemlist("printf " . cleaned_lines . " | " . cmd)
    endif
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

" from https://gist.github.com/romainl/5b827f4aafa7ee29bdc70282ecc31640
command! -range GBlame echo join(systemlist("git -C " . shellescape(expand('%:p:h')) . " blame -L <line1>,<line2> " . expand('%:t')), "\n")

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
command! -bar -nargs=? TrimTrailingWhitespaces
      \ call s:TrimTrailingWhitespaces()
" autocmd FileType c,cpp,java,php,ruby,python autocmd BufWritePre <buffer> :call <SID>TrimTrailingWhitespaces()

let g:python3_host_prog = "$HOME/miniconda3/bin/python3"

" from https://gist.github.com/PeterRincker/69b536f303f648cc21ec2ff2282f8c4a
function! Diff(mods, spec)
  let l:truecwd = getcwd()
  let l:root_identifiers = g:rooter_patterns
  let g:rooter_patterns = ['.git']

  let mods = a:mods
  if !len(mods) && &diffopt =~ 'vertical'
    let mods = 'vertical'
  endif
  execute mods . ' new'
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

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap gb <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap gb <Plug>(EasyAlign)

let g:easy_align_delimiters = {
\   '/': {
\       'pattern': '\/\/',
\   },
\ }
