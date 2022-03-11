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
" additionally see this: https://github.com/jsatk/dotfiles/blob/52aa72c9a277d8caaa01ace7df4c888e46b5bb8e/tag-vim/vimrc#L712-L713
" Notice `:h secure` says to put itself at the bottom of vimrc. Also, with
" `set exrc` set, I might not need exrc plugin (but why it then exists at the
" very first place?)

" which key prompt wait time
set timeoutlen=1000
lua << EOF
  require("which-key").setup {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  }
EOF

" FixCursorHold.nvim
let g:cursorhold_updatetime = 150

if has('termguicolors')
  set termguicolors
endif

" Need this to change cursor color https://github.com/neovim/neovim/issues/12626#issuecomment-799077796.
" Disabling this for zenwritten as txt color is same as cursor color so text becomes hard to read
" set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor
" aug kitty_cursor
"   au!
"   au Colorscheme * set guicursor=n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor
" aug END

function! CustomZenwritten() abort
  hi CmpGhostText guifg=#686868
  highlight link PounceMatch NormalFloat
  highlight link PounceGap NormalFloat
  hi PounceKey guifg=#6099C0 guibg=#202223 gui=bold
  hi link PounceAccept PounceKey
  hi link PounceAcceptBest PounceKey
  " switch to CursorLine if it bothers you
  hi link MatchWord NormalFloat

  sign define DiagnosticSignError text=│ texthl=DiagnosticSignError
  sign define DiagnosticSignWarn text=│ texthl=DiagnosticSignWarn
  sign define DiagnosticSignInfo text=│ texthl=DiagnosticSignInfo
  sign define DiagnosticSignHint text=│ texthl=DiagnosticSignHint
endfunction

augroup MyColors
  autocmd!
  autocmd ColorScheme zenwritten call CustomZenwritten()
augroup END

colorscheme zenwritten

nnoremap <space> <nop>
let mapleader = "\<Space>"

set mouse=nv

set signcolumn=yes
set number relativenumber

set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*,*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls,*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*/dist/*,*/build/*,.idea/**,*DS_Store*,*/coverage/*,*/.git/*,*/package-lock.json,*/yarn.lock,*/go.sum

if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()

" FIXME tmp fix for https://github.com/nvim-telescope/telescope.nvim/issues/699
set foldlevel=21
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

" set list listchars=tab:ᐅ\ ,extends:>,precedes:<,nbsp:~
set list listchars=tab:\ \ ,extends:>,precedes:<,nbsp:~
augroup trailing
  autocmd!
  autocmd InsertEnter * :set listchars-=trail:·
  autocmd InsertLeave * :set listchars+=trail:·
augroup END

set inccommand=nosplit
set ignorecase
set smartcase

set shiftround

" line up down in visual mode using ctrl+j/k
vnoremap <silent><c-j> :m '>+1<cr>gv=gv
vnoremap <silent><c-k> :m '<-2<cr>gv=gv

if has("persistent_undo")
  let target_path = stdpath('data') . '/.undodir'

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
" keeps cursor at same place when cloning the buffer in new tab
call SetupCommandAlias("bt","tab sb")
call SetupCommandAlias("rg","GrepLiteral")

set nowrap
" https://stackoverflow.com/questions/13294489/make-vim-only-do-a-soft-word-wrap-not-hard-word-wrap
set linebreak

source ~/.config/nvim/mine/indent.vim

set jumpoptions+=stack
" also see keepjumps command in help, useful in your scripts
" and changelist for general movements

" goto file and create it if is not present
" from https://stackoverflow.com/a/29068665/7683365
function! Gf()
  let l:filepath = expand('<cfile>')
  let l:curr_buf_path = expand("%:p:h")
  let l:fullpath = ''

  try
    if l:filepath[0:len('./')-1] ==# './' || l:filepath[0:len('../')-1] ==# '../'
      let l:fullpath = resolve(l:curr_buf_path . '/' . l:filepath)

      if !filereadable(l:fullpath)
        exec "normal! gf"
      endif

      let l:cwd = getcwd()
      if getcwd() ==# l:fullpath[0:len(l:cwd)-1]
        exec 'edit ' . l:fullpath[len(l:cwd)+1:]
      else
        exec 'edit ' l:fullpath
      endif
    else
      exec "normal! gf"
    endif
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

    if len(l:fullpath)
      let l:cwd = getcwd()
      if getcwd() ==# l:fullpath[0:len(l:cwd)-1]
        exec 'edit ' . l:fullpath[len(l:cwd)+1:]
      else
        exec 'edit ' l:fullpath
      endif
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
" Eg. :Redir g=term-to-search

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

" select the lines where I just pasted
" useful when `=` is pressed after it to do an indent on that pasted text
nmap <leader>= V`]

" Paste last yank we made (let's don't muck with black hole register)
nmap <leader>p "0p
vmap <leader>p "0p
nmap <leader>P "0P
vmap <leader>P "0P
nmap <leader>gp "0gp
vmap <leader>gp "0gp
nmap <leader>gP "0gP
vmap <leader>gP "0gP

" slightly modified vimtip mentioned in https://github.com/inkarkat/vim-UnconditionalPaste
function! PasteJointCharacterwise(regname, pastecmd)
  let l:reg_type = getregtype(a:regname)
  let l:reg_val = getreg(a:regname)
  call setreg(a:regname, l:reg_val, "c")
  exe 'normal "'. a:regname . a:pastecmd
  call setreg(a:regname, l:reg_val, l:reg_type)
  exe 'normal `[v`]gJ'
endfunction
nmap <silent><Leader>cp :call PasteJointCharacterwise(v:register, "p")<CR>
nmap <silent><Leader>cP :call PasteJointCharacterwise(v:register, "P")<CR>
vmap <silent><Leader>cp :call PasteJointCharacterwise(v:register, "p")<CR>
vmap <silent><Leader>cP :call PasteJointCharacterwise(v:register, "P")<CR>

function s:decideForSysClipboard()
  let l:char = nr2char(getchar())

  if l:char == 'r' || l:char == 'c'
    return '"+' . g:mapleader . l:char
  elseif empty(l:char)
    return ''
  else
    return '"+' . l:char
  end
endfunction

nmap <expr> <leader>v <sid>decideForSysClipboard()
vmap <expr> <leader>v <sid>decideForSysClipboard()

" better diffing
set diffopt+=algorithm:histogram,indent-heuristic,vertical
" haven't tried this:
" set diffopt+=iwhite
" you can set context too, see https://unix.stackexchange.com/a/290501
" more https://unix.stackexchange.com/a/352204

" use q to quickly escape out from vim help
autocmd Filetype help nnoremap <buffer> q :q<cr>
" F5 to execute the command while keeping the command window open
autocmd CmdwinEnter * nnoremap <buffer><silent> <F5> :let g:CmdWindowLineMark=line(".")<CR><CR>q::execute "normal ".g:CmdWindowLineMark."G"<CR>
" <c-c> quits command window, so don't map q or esc for it

let g:root_markers = ['src', 'package.json', 'go.mod', 'Makefile', '.git']

" noshowmode hides default mode display as we are using custom statusline
set noshowmode
lua << END
require('lualine').setup({
  options = {
    icons_enabled = false,
  },
  sections = {
    lualine_b = {'diagnostics'},
    lualine_x = {"require'nvim-lightbulb'.get_status_text()", 'filetype'},
  },
})
END

let s:show_matchup_popup = v:false
let g:matchup_matchparen_offscreen = {}
function! <sid>MatchupPairPopupToggle()
  if s:show_matchup_popup
    let s:show_matchup_popup = v:false
    let g:matchup_matchparen_offscreen = {}
    call matchup#matchparen#update()
  else
    let s:show_matchup_popup = v:true
    let g:matchup_matchparen_offscreen = {'method': 'popup'}
    call matchup#matchparen#update()
  endif
endfunction
command! MatchupPairPopupToggle
      \ call s:MatchupPairPopupToggle()

function! <sid>MatchupPairPopupDisable()
  let s:show_matchup_popup = v:false
  let g:matchup_matchparen_offscreen = {}
  call matchup#matchparen#update()
endfunction
command! MatchupPairPopupDisable
      \ call s:MatchupPairPopupDisable()

luafile ~/.config/nvim/mine/treesitter-and-comment.lua

" exit fzf using <c-c> or <c-q> https://github.com/junegunn/fzf.vim/issues/544
" from https://github.com/junegunn/fzf/issues/1393#issuecomment-426576577
" commenting as when used inside nvim-bqf, it removes qf list buffer too
" autocmd! FileType fzf tnoremap <buffer> <esc> <c-c>

lua <<EOF
local actions = require"telescope.actions"

require('telescope').setup{
  defaults = require("telescope.themes").get_ivy {
    layout_config = {
      height = 22,
    },

    mappings = {
      i = {
        -- had to comment it as pressing esc moves the cursor left by one char
        -- ^ TODO uncommented as we've a filed issue: https://github.com/nvim-telescope/telescope.nvim/issues/1185
        ["<esc>"] = actions.close
      }
    },

    file_ignore_patterns = {
      ".git/",
      ".DS_Store", ".vscode/",
      "node_modules/", "__pycache__/",
      "package%-lock.json", "yarn.lock", "pnpm%-lock.yaml",
      "build/", "dist/",
      "go.sum",
    },
    -- ^ telescope uses lua's pattern matching library, see:
    -- https://github.com/nvim-telescope/telescope.nvim/issues/780
    -- https://gitspartv.github.io/lua-patterns/
  }
}

require("telescope").load_extension("zf-native")
EOF

" for completion
set completeopt=menu,menuone,noselect
set pumheight=8

lua require('nvim-autopairs').setup{}
autocmd BufRead,BufNewFile */node_modules/* lua vim.diagnostic.disable(0)
luafile ~/.config/nvim/mine/snippets.lua
lua require"mine.lsp"

command! EchoLineDiagnostics lua require('mine.lsp.diagnostics').echo_line_diagnostics()
command! PutErrorsInLocationList lua vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR })

lua <<EOF
require('pqf').setup({
  signs = {
    error = 'E',
    warning = 'W',
    info = 'I',
    hint = 'H'
  }
})
EOF

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

" We are using <c-z> to simulate tab, see
" https://stackoverflow.com/questions/32513835/create-vim-map-that-executes-tab-autocomplete
set wildcharm=<c-z>
" We are using : over <cmd> so vim doesn't ask us to append <cr> at the
" end. More separators here ->
" http://vimdoc.sourceforge.net/htmldoc/cmdline.html#filename-modifiers
"
" space and backspace are added to prevent autosuggest from showing parent folder
" suggestions
nnoremap <leader>f. :e %:.:h<c-z><space><bs>
nnoremap <leader>> :e %:.:h<c-z><space><bs>

nmap <leader>. <cmd>lua require"telescope.builtin".find_files({ cwd = require"telescope.utils".buffer_dir(), hidden = true })<cr>

" indent file without leaving cursor pos
" from https://stackoverflow.com/a/20110045/7683365
nnoremap g= :let b:PlugView=winsaveview()<CR>gg=G:call winrestview(b:PlugView) <CR>:echo "file indented"<CR>

runtime macros/sandwich/keymap/surround.vim

nmap s <cmd>Pounce<CR>
nmap S <cmd>PounceRepeat<CR>
vmap s <cmd>Pounce<CR>
" as 's' is used by vim-surround:
omap gs <cmd>Pounce<CR>

xmap gl <Plug>(EasyAlign)
nmap gl <Plug>(EasyAlign)
let g:easy_align_delimiters = {
      \   '/': {
      \       'pattern': '\/\/',
      \   },
      \ }

" put folders and hidden files first
let g:dirvish_mode = ':sort | sort ,^.*[^/]$, r | silent keeppatterns g/\.git\/$/d'
augroup dirvish_config
  autocmd!
  autocmd FileType dirvish nnoremap <silent><buffer>
        \ gh :silent keeppatterns g@\v/\.[^\/]+/?$@d _<cr>:setl cole=2<cr>
  autocmd FileType dirvish nnoremap <silent><buffer> r <cmd>setlocal conceallevel=2<cr>
  autocmd FileType dirvish nmap <silent><buffer> h <Plug>(dirvish_up)
  autocmd FileType dirvish nmap <silent><buffer> l <cmd>call dirvish#open("edit", 0)<cr>
  autocmd FileType dirvish silent! unmap <buffer> -
  autocmd FileType dirvish nmap <silent><buffer> - <cmd>Dirvish<cr>
augroup END

nmap <leader>r <plug>(SubversiveSubstitute)
nmap <leader>rr <plug>(SubversiveSubstituteLine)
nmap <leader>R <plug>(SubversiveSubstituteToEndOfLine)
nmap \ <plug>(SubversiveSubstituteRange)
xmap \ <plug>(SubversiveSubstituteRange)
nmap \\ <plug>(SubversiveSubstituteWordRange)
nmap <leader>\ <plug>(SubversiveSubstituteRangeConfirm)
xmap <leader>\ <plug>(SubversiveSubstituteRangeConfirm)
nmap <leader>\\ <plug>(SubversiveSubstituteWordRangeConfirm)

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

" modified form of https://gist.github.com/PeterRincker/69b536f303f648cc21ec2ff2282f8c4a
function! Diff(mods, spec)
  let l:mods = a:mods
  if !len(l:mods) && &diffopt =~ 'vertical'
    let l:mods = 'vertical'
  endif
  execute 'topleft ' . l:mods . ' new'
  setlocal bufhidden=wipe buftype=nofile nobuflisted noswapfile
  let l:cmd = "++edit #"

  if len(a:spec)
    let l:cmd = "!git show " . a:spec . ":./#"
  endif

  execute "read " . l:cmd
  silent 0d_
  let &filetype = getbufvar('#', '&filetype')
  augroup Diff
    autocmd!
    autocmd BufWipeout <buffer> diffoff!
  augroup END
  diffthis
  nnoremap <buffer>q <C-W>c

  wincmd p
  diffthis

  wincmd p
endfunction
command! -nargs=? Diff call Diff(<q-mods>, <q-args>)

" let g:python3_host_prog = "$HOME/miniconda3/bin/python3"

function! s:PutModifiedFilesInArglist()
  arglocal
  silent! argdelete *
  bufdo if &modified | argadd | endif
  first
endfunction

command! PutModifiedFilesInArglist
      \ call s:PutModifiedFilesInArglist()

source ~/.config/nvim/mine/blame.vim

lua <<EOF
require"gitlinker".setup({ mappings = false })
vim.api.nvim_set_keymap('n', '<leader>cgx', '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', {silent = true})
vim.api.nvim_set_keymap('v', '<leader>cgx', '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', {})
EOF

function! s:arrayify(bang, ...) range abort
  let quote_begin = get(a:, 1, "")
  let quote_end   = get(a:, 2, quote_begin)
  let lines = getline(a:firstline, a:lastline)
  if a:bang != '!'
    " bang => don't filter out empty lines
    call filter(lines, {_, l -> l !~ '^\s*$'})
  endif
  call map(lines, {_, l -> l:quote_begin . l . l:quote_end})
        \ ->join(', ')
        \ ->setline(a:firstline)
  call deletebufline('%', a:firstline+1, a:lastline)
endfunction

command! -bang -nargs=* -range=1 Arrayify
      \ <line1>,<line2>call s:arrayify("<bang>", <f-args>)

lua <<EOF
-- Update: use `lua =obj` rather `lua print(dump(obj))`
-- from https://stackoverflow.com/questions/9168058/how-to-dump-a-table-to-console
function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
EOF

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

function s:PutFileName() abort
  call feedkeys(expand('%:t:r'))
endfunction
imap <c-g>n <cmd>call <sid>PutFileName()<cr>

" TODO add vim-repeat to next/prev, same for navigating to next/prev diagnostic
" unimpared like mapping for arglist
nnoremap [a <cmd>prev<cr><cmd>call repeat#set("[a")<cr>
nnoremap ]a <cmd>next<cr><cmd>call repeat#set("]a")<cr>
nnoremap [A <cmd>first<cr>
nnoremap ]A <cmd>last<cr>

" unimpared like mapping for location list
nnoremap [l <cmd>lprev<cr><cmd>call repeat#set("[l")<cr>
nnoremap ]l <cmd>lnext<cr><cmd>call repeat#set("]l")<cr>
nnoremap [L <cmd>lfirst<cr>
nnoremap ]L <cmd>llast<cr>

" unimpared like mapping for quickfix list
nnoremap [q <cmd>cprev<cr><cmd>call repeat#set("[q")<cr>
nnoremap ]q <cmd>cnext<cr><cmd>call repeat#set("]q")<cr>
nnoremap [Q <cmd>cfirst<cr>
nnoremap ]Q <cmd>clast<cr>

" wrap for comments, see :h gq. Earlier it was mapped to gq_ (not to be
" confused with g_ which is used to go to last non-whitespace char)
nmap Q gqic

source ~/.config/nvim/mine/quickswitch.vim
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

let g:bettergrep_no_mappings = 1
let g:bettergrep_no_abbrev = 1
" better if adjusted per-project using .exrc:
" let g:bettergrepprg = "rg --vimgrep --smart-case -g '!*yarn.lock' -g '!*package-lock.json'"
" not sure how I can re-use wildignore here (or even if it is needed)
let g:bettergrepprg = "rg --vimgrep --smart-case"

command! -nargs=+ GrepLiteral call GrepLiteral(<q-args>)
function! GrepLiteral(query)
  let l:query = a:query

  " counts deduced by hit and trial:
  " execute("Grep -F '\\\"pack'")
  " execute("Grep -F '\\\\\\'pack'")

  let l:c = 1
  while l:c <=3
    let l:query = escape(l:query, '"')
    let l:c += 1
  endwhile

  let l:c = 1
  while l:c <=6
    let l:query = escape(l:query, "'")
    let l:c += 1
  endwhile

  " -F is passed to ripgrep to make a literal search
  execute("Grep -F " . "'" . l:query . "'")
endfunction

" from https://stackoverflow.com/a/6271254/7683365
function! GetVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

" other ways to grab current word are listed here https://stackoverflow.com/questions/31755115/call-vim-function-with-current-word
nmap <leader>* <cmd>call GrepLiteral(expand('<cword>'))<cr>
vmap <leader>* :<c-u>execute "GrepLiteral " . GetVisualSelection()<cr>

nmap <leader>/ <plug>(esearch)
map  <leader>? <plug>(operator-esearch-prefill)
let g:esearch = {}
let g:esearch.root_markers = g:root_markers

lua <<EOF
vim.diagnostic.config({ virtual_text = false, severity_sort = true, underline = false })

local keymap = require("which-key").register
keymap({
    ["`"] = { "<cmd>e $MYVIMRC<cr>", "edit vimrc" },
    a = { "<c-^>", "alt buffer" },
    s = { "<cmd>Telescope buffers<cr>", "switch to buffer" },
    ["'"] = { "<cmd>Telescope resume<cr>", "resume search" },
    d = { "<cmd>lua vim.diagnostic.open_float()<cr>", "diagnostic at cursor" },
    t = {
      name = "toggle visibility",
      -- if offscreen
      ["%"] = { "<cmd>TSContextDisable<cr><cmd>MatchupPairPopupToggle<cr>", "matching pair" },
      -- if offscreen
      c = { "<cmd>MatchupPairPopupDisable<cr><cmd>TSContextToggle<cr>", "code context" },
    },
    w = {
      name = "workspace",
      m  = { "<cmd>Telescope marks<cr>", "marks" },
      t  = { "<cmd>Telescope tagstack<cr>", "tagstack" },
    },
    f = {
      name = "file",
      f  = { "<cmd>Telescope find_files hidden=true<cr>", "find" },
      ["/"] = {"<cmd>Telescope current_buffer_fuzzy_find<cr>", "search buffer"},
      o  = { "<cmd>Telescope oldfiles cwd_only=true<cr>", "old files" },
      u  = { ":undolist<CR>:u<Space>", "undo list" },
      l = { ":call cursor()<left>", "goto line" },
      y = {
        name = "yank",
        p  = { '<cmd>let @" = expand("%")<cr>', "path" },
        P  = { '<cmd>let @+ = expand("%")<cr>', "path to clipboard" },
        n  = { '<cmd>let @" = expand("%:t")<cr>', "name" },
        N  = { '<cmd>let @+ = expand("%:t")<cr>', "name to clipboard" },
      },
    },
    ["<space>"] = { "<cmd>Telescope gtags gtags<cr>", "find files" },
    ["-"] = { "<cmd>Telescope open_dir open_dir<cr>", "find dir" },
  }, {
    prefix = "<leader>",
  })
EOF

lua <<EOF
-- require('neogen').setup {}

require"bqf".setup {
  preview = {
    win_height = 999
  }
}
EOF

" quick horizontal find
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" Quick scope (horizontal navigation using find) token colors
" highlight QuickScopePrimary guifg='#6bdeba' gui=underline ctermfg=81
highlight QuickScopePrimary guifg='#6ade93' gui=underline ctermfg=81
highlight QuickScopeSecondary guifg='#ffa9d5' gui=underline ctermfg=81

let g:rooter_patterns = g:root_markers

" don't search for parent directory for tags
" https://vi.stackexchange.com/questions/13509/use-only-closest-tagfile-to-working-directory-of-buffer-or-of-vim-process
" (PS: turns out setglobal tags?, set tags? and setlocal tags? give different values)
" Now I have two solutions, one being:
set tags=
" ^ this works perfectly in all cases but doesn't generate tags and loads tag file
" when Dirvish is opened.
" another is to do:
" set tags=tags
" this would load up the tagfile, but (probably) won't update tags if you change
" git branch for example (as GutentagsUpdate command is not available in
" Dirvish)
"
" so unless the repo isn't monorepo, I would still suggest to put `.notags`
" file at root to avoid extraneous tag generation

let g:gutentags_project_root = g:root_markers
let g:gutentags_generate_on_empty_buffer = 1
let g:gutentags_cache_dir = stdpath('cache') . '/project-tags'

function <sid>GutentagsAutoUpdate() abort
  if !exists(':GutentagsUpdate')
    return
  endif
  GutentagsUpdate!
endfunction

augroup gutentags_auto_update
  autocmd!
  autocmd FocusGained * call <sid>GutentagsAutoUpdate()
augroup END

" what is the point of saving blank (empty) windows?
set sessionoptions-=blank
set sessionoptions+=winpos,terminal

autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb({sign = { enabled = false }, status_text = { enabled = true }})

" runs command on cursor line and replaces the line with shell output
nmap <leader>! !!$SHELL<CR>

" ctrl+s to save
inoremap <c-s> <esc><cmd>w<cr>
" to keep yourself in insert mode, use inoremap <c-s> <c-o><cmd>w<cr>
nnoremap <c-s> <esc><cmd>w<cr>
xnoremap <c-s> <esc><cmd>w<cr>gv

let g:interestingWordsGUIColors =["#ffa724", "#aeee00", "#8cffba", "#b88853", "#ff9eb8", "#ff2c4b"] 
let g:interestingWordsDefaultMappings = 0
nnoremap <silent> <leader>m :call InterestingWords('n')<cr>
vnoremap <silent> <leader>m :call InterestingWords('v')<cr>
nnoremap <silent> <leader>M :call UncolorAllWords()<cr>
" somehow results in hiding [3/34] that appears at bottom right at command
" line
" nnoremap <silent> n :call WordNavigation(1)<cr>
" nnoremap <silent> N :call WordNavigation(0)<cr>

function! MarkdownPreviewInBrowserFn(url) abort
  " taken from https://github.com/ajitid/dotfiles/blob/da7fcc455fd6e9d89b7b79be8b19216d32aaf055/archived/nvim-2021/.config/nvim/init.vim#L575-L587
  if !exists('g:loaded_netrw')
    runtime! autoload/netrw.vim
  endif

  if exists('*netrw#BrowseX')
    call netrw#BrowseX(a:url, 0)
  endif

  if has('clipboard')
    let @+ = a:url
    echo 'Opening URL in browser, it has been copied to clipboard too.'
  endif
endfunction
let g:mkdp_browserfunc = 'MarkdownPreviewInBrowserFn'

" from https://github.com/marcelbeumer/dotfiles/blob/8fbe4d2ab5e812f1315626fb642fca386ee281e7/nvim/lua/nvim_marcel/etc/date.lua#L2
function! DateStrPretty() range
  return system('date "+%Y-%m-%d %H:%M:%S" | tr -d "\n"')
endfunction

let g:vmt_fence_text = 'TOC'
let g:vmt_fence_closing_text = '/TOC'
" allows you to delete GFM from opening fence text and still use update toc
" command
let g:vmt_fence_hidden_markdown_style = 'GFM'

let g:Hexokinase_highlighters = ['backgroundfull']

" This function defines what folded text looks like.
function! MyFoldText()
  let line = getline(v:foldstart)

  let nucolwidth = &fdc + &number * &numberwidth
  let windowwidth = winwidth(0) - nucolwidth - 3
  let foldedlinecount = v:foldend - v:foldstart

  " expand tabs into spaces
  let onetab = strpart(' ', 0, &tabstop)
  let line = substitute(line, '\t', onetab, 'g')

  let line = strpart(line, 0, windowwidth - 2 -len(foldedlinecount))
  let fillcharcount = windowwidth - len(line) - len(foldedlinecount)
  return line . '…' . repeat(" ",fillcharcount) . foldedlinecount . '…' . ' '
endfunction
set foldtext=MyFoldText()

" highlight current line when that window (buffer) is not in focus
augroup cline
  autocmd!
  autocmd WinLeave * set cursorline
  autocmd WinEnter * set nocursorline
augroup END

" removes ^M sign, from https://vim.fandom.com/wiki/File_format#Converting_the_current_file
function! DosToUnix()
  setlocal ff=unix
  update
  edit
  " repeating same commands again is intentional:
  setlocal ff=unix
  update
endfunction
command! DosToUnix call DosToUnix()

" stolen parts from https://github.com/fatih/vim-go/
source ~/.config/nvim/mine/go/init.vim

lua require("highlight_current_n").setup({})
nmap n <Plug>(highlight-current-n-n)
nmap N <Plug>(highlight-current-n-N)
autocmd CmdlineLeave /,\? lua require('highlight_current_n')['/,?']()
