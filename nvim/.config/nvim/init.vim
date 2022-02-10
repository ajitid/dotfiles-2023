source ~/.config/nvim/mine/plugins.vim

set fillchars=eob:\ ,
set shm+=Ic
set noswapfile
set lazyredraw

" prevents security exploits, see http://lists.alioth.debian.org/pipermail/pkg-vim-maintainers/2007-June/004020.html
" for better solutions see:
" there might be a better solution for it, see:
" - https://news.ycombinator.com/item?id=20098691 and
" - https://github.com/ciaranm/securemodelines
" there is also `secure` https://vi.stackexchange.com/questions/5055/why-is-set-exrc-dangerous
" ii14/exrc.vim which I've installed might help to guard against this
set modelines=0

" which key prompt wait time
set timeoutlen=1500

" FixCursorHold.nvim
let g:cursorhold_updatetime = 400

if has('termguicolors')
  set termguicolors
endif

" need this to change cursor color https://github.com/neovim/neovim/issues/12626#issuecomment-799077796
set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor
aug kitty_cursor
  au!
  au Colorscheme * set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor
aug END

colorscheme kanagawa

nnoremap <space> <nop>
let mapleader = "\<Space>"

set mouse=nv

set signcolumn=yes
set number relativenumber

set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*,*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls,*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*/dist/*,*/build/*,.idea/**,*DS_Store*,*/coverage/*,*/.git/*,*/package-lock.json

if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

set foldlevel=21
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
" tmp fix for https://github.com/nvim-telescope/telescope.nvim/issues/699
augroup fix_folds
  autocmd!
  autocmd BufNewFile,BufRead *.* norm! zx
augroup END

nnoremap ; :
nnoremap , ;
vnoremap ; :
vnoremap , ;

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

nnoremap <expr> j v:count == 0 ? 'gj' : "\<Esc>".v:count.'j'
nnoremap <expr> k v:count == 0 ? 'gk' : "\<Esc>".v:count.'k'

set scrolloff=3

set list listchars=tab:ᐅ\ ,trail:·,extends:>,precedes:<,nbsp:~

set inccommand=nosplit
set ignorecase
set smartcase

" that \V is related to magic/no-magic in vim incremental search
nnoremap <leader>/ /\V
nnoremap <leader>? ?\V

" line up down in visual mode using ctrl+j/k
vnoremap <silent><c-j> :m '>+1<cr>gv=gv
vnoremap <silent><c-k> :m '<-2<cr>gv=gv

if has("persistent_undo")
  let target_path = expand('~/mytmp/.undodir')

  " create the directory and any parent directories
  " if the location does not exist.
  if !isdirectory(target_path)
    call mkdir(target_path, "p", 0700)
  endif

  let &undodir=target_path
  set undofile
endif

set splitbelow
set splitright

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

fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

call SetupCommandAlias("nt","tabnew")
call SetupCommandAlias("rg","GrepLiteral")

let g:bettergrep_no_mappings = 1
let g:bettergrep_no_abbrev = 1

command! -nargs=+ GrepLiteral call GrepLiteral(<q-args>)
function! GrepLiteral(query)
  " -F is passed to ripgrep to make a literal search
  execute("Grep -F " . "'" . a:query . "'")
endfunction

" other ways to grab current word are listed here https://stackoverflow.com/questions/31755115/call-vim-function-with-current-word
nmap <leader>* <cmd>call GrepLiteral(expand('<cword>'))<cr>

set nowrap

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

" for file type ~/.vim/after/ftplugin/html.vim as `setlocal shiftwidth=2`
" other way could be: autocmd BufRead,BufNewFile   *.c,*.h,*.java set noic cin noexpandtab
" TODO doesn't sets indentation
augroup filetype_based_indentation
  autocmd!
  autocmd VimEnter * set tabstop=2 softtabstop=2 shiftwidth=2 expandtab
  autocmd FileType python,rust setlocal tabstop=4 softtabstop=4 shiftwidth=4 expandtab
augroup END

" what is the point of saving blank (empty) windows?
set sessionoptions-=blank

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

nnoremap gl :call cursor()<left>

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank {higroup="IncSearch", timeout=250}
augroup END

augroup yank_restore_cursor
  autocmd!
  autocmd VimEnter,CursorMoved *
    \ let s:cursor = getpos('.')
  autocmd TextYankPost *
    \ if v:event.operator ==? 'y' |
    \   call setpos('.', s:cursor) |
    \ endif
augroup END

" paste + indent
nnoremap p p=`]
vnoremap p p=`]
nnoremap P P=`]
vnoremap P P=`]
nnoremap gp gp=`]
vnoremap gp gp=`]
nnoremap gP gP=`]
vnoremap gP gP=`]

" Paste last yank we made (let's don't muck with black hole register)
nmap <leader>p "0p
vmap <leader>p "0p
nmap <leader>P "0P
vmap <leader>P "0P
nmap <leader>gp "0gp
vmap <leader>gp "0gp
nmap <leader>gP "0gP
vmap <leader>gP "0gP

" better diffing
set diffopt+=algorithm:histogram,indent-heuristic,vertical
" haven't tried this:
" set diffopt+=iwhite
" you can set context too, see https://unix.stackexchange.com/a/290501
" more https://unix.stackexchange.com/a/352204

" use q to quickly escape out from vim help
autocmd Filetype help nnoremap <buffer> q :q<cr>

nnoremap <leader>l <cmd>noh<cr><cmd>echo ''<cr>

" noshowmode hides default mode display as we are using custom statusline
set noshowmode
lua << END
require('lualine').setup()
END

let g:lastplace_open_folds = 0
let g:rooter_patterns = ['src', '.git', 'Makefile', 'node_modules', 'go.mod']

luafile ~/.config/nvim/mine/treesitter-and-comment.lua

lua <<EOF
require('telescope').setup{
  defaults = require("telescope.themes").get_ivy {
    layout_config = {
      height = 15,
    },
  }
}
EOF

" for completion
set completeopt=menu,menuone,noselect
set pumheight=8

luafile ~/.config/nvim/mine/snippets.lua
luafile ~/.config/nvim/mine/lsp-and-completion.lua

lua <<EOF
require"fidget".setup{}
EOF

nmap <leader>ff <cmd>Telescope find_files<cr>

lua require('pqf').setup()

lua <<EOF
require'treesitter-context'.setup{
    enable = false,
    throttle = true,
    max_lines = 4,
    patterns = {
        default = {
            'class',
            'function',
            'method',
            'for',
            'while',
            'if',
            'switch',
            'case',
        },
        -- Example for a specific filetype.
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        --   rust = {
        --       'impl_item',
        --   },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true, 
    }
}
EOF

nmap <silent><leader>cc <cmd>TSContextToggle<cr>

" yank file name/relative path wrt project root to default/system clipboard
nnoremap <leader>fyp <cmd>let @" = expand("%")<cr>
nnoremap <leader>fyP <cmd>let @+ = expand("%")<cr>
nnoremap <leader>fyn <cmd>let @" = expand("%:t")<cr>
nnoremap <leader>fyN <cmd>let @+ = expand("%:t")<cr>

" We are using <c-z> to simulate tab, see
" https://stackoverflow.com/questions/32513835/create-vim-map-that-executes-tab-autocomplete
set wildcharm=<c-z>

" show an option to edit wrt file's parent dir, useful to create a file at the
" same place where buffer's file lives
nnoremap <leader>f. :e %:.:h<c-z><space><bs>
" space and backspace are added to prevent autosuggest from showing parent folder suggestions
" Also, we are using : over <cmd> so vim doesn't ask us to append <cr> at the
" end. More separators here ->
" http://vimdoc.sourceforge.net/htmldoc/cmdline.html#filename-modifiers

" {{{ highlight line
function! HighlightLine()
  if !exists("b:highlightline")
    setlocal cursorline
    let b:highlightline=1
  else
    setlocal nocursorline
    unlet b:highlightline
  endif
endfunction

function! ClearHighlightLine()
  if exists("b:highlightline")
    setlocal nocursorline
    unlet b:highlightline
  endif
endfunction

augroup highlight_line
  autocmd!
  autocmd CursorMoved * autocmd highlight_line CursorMoved * call ClearHighlightLine()
augroup END
" }}}

" indent file without leaving cursor pos
" from https://stackoverflow.com/a/20110045/7683365
nnoremap g= :let b:PlugView=winsaveview()<CR>gg=G:call winrestview(b:PlugView) <CR>:echo "file indented"<CR>

runtime macros/sandwich/keymap/surround.vim

nmap s <cmd>Pounce<CR>
nmap S <cmd>PounceRepeat<CR>
vmap s <cmd>Pounce<CR>
" as 's' is used by vim-surround:
omap gs <cmd>Pounce<CR>

xmap gs <Plug>(EasyAlign)
nmap gs <Plug>(EasyAlign)

" put folders and hidden files first
let g:dirvish_mode = ':sort | sort ,^.*[^/]$, r'

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
