source ~/.config/nvim/mine/plugins.vim
" didn't worked for me (tell me it could find plug command) but have a look at it anyway:
" https://github.com/junegunn/vim-plug/issues/954#issuecomment-608878431
" PlugSnapshot ~/.config/nvim/mine/plug-snapshot.vim

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

" FixCursorHold.nvim
let g:cursorhold_updatetime = 150

" which key prompt wait time
set timeoutlen=1000
lua << EOF
require("which-key").setup {
  plugins = {
    presets = {
        g = false,
        text_objects = false,
        motions = false,
        operators = true,
    },
  },
}
EOF

if has('termguicolors')
  set termguicolors
endif

function! CustomTheme() abort
  " https://www.reddit.com/r/neovim/comments/m8zedt/how_to_change_a_particular_syntax_token_highlight/
  " https://github.com/nvim-treesitter/nvim-treesitter/issues/519#issuecomment-712533798
  hi! link @punctuation.delimiter Comment
  hi link @md.link @punctuation.delimiter
  hi @text.strong guifg=#d0d0d0 gui=bold
  hi @text.emphasis gui=italic
  hi Title guifg=#bad7ff gui=bold
  " means inline code and ``` code w/o syntax highlight
  hi @text.literal guifg=#88afa2

  hi TabLineFill guibg=NONE
  hi TabLine guifg=#6a6a69 guibg=NONE
  hi TabLineSel guifg=#bbbbbb guibg=#202020

  " remove underline from markdown links
  hi Underlined gui=NONE

  hi CmpGhostText guifg=#686868

  " text selection color
  hi Visual ctermbg=242 guibg=#202020
  hi TermCursor guifg=#151515 guibg=#d0d0d0
  hi link TermCursorNC TermCursor
  hi! link Cursor TermCursor

  hi MatchParen guifg=NONE guibg=#303035 gui=NONE
  hi MatchParenCur gui=NONE
  hi MatchWord gui=underdotted
  hi MatchWordCur gui=underdotted

  hi link FzfLuaCursorLine None
  hi FzfLuaBorder guifg=#303035

  " alt color " hi Search guifg=wheat guibg=#261f18
  hi Search guifg=wheat guibg=#261f18
  " apply highlight to first match while searching
  hi IncSearch guifg=#b3f5c4 guibg=#202b1b
  " apply this highlight instead if cursor on a search term
  hi CurSearch guifg=#b3f5c4 guibg=#202b1b

  hi PounceMatch guibg=#202025
  hi PounceGap guibg=#202025
  hi PounceKey guifg=wheat guibg=#261f18 gui=bold
  hi link PounceAccept PounceKey
  hi link PounceAcceptBest PounceKey
  " BUG, FIXME has this while TODO has its own highlight key called @text.todo
  hi link @text.danger Todo

  sign define DiagnosticSignError text=│ texthl=DiagnosticSignError
  sign define DiagnosticSignWarn text=│ texthl=DiagnosticSignWarn
  sign define DiagnosticSignInfo text=│ texthl=DiagnosticSignInfo
  sign define DiagnosticSignHint text=│ texthl=DiagnosticSignHint

  " hi DiagnosticSignError guibg=NONE
  " and same for rest if you want to remove bg
endfunction

augroup MyColors
  autocmd!
  autocmd ColorScheme no-clown-fiesta call CustomTheme()
augroup END

colorscheme no-clown-fiesta

nnoremap <space> <nop>
let mapleader = "\<Space>"

" from https://github.com/neovim/neovim/pull/17932#issuecomment-1113997721
nmap <tab> %
nnoremap <c-i> <c-i>
xmap <tab> %

set cursorline
set cursorlineopt=number
set signcolumn=yes
set number relativenumber

set mouse=nv
" https://github.com/ajitid/dotfiles/blob/337e334fda45098198317111b3e7e47979c00362/archived/nvim-2021/.config/nvim/init.vim#L112-L116
autocmd FocusGained * call timer_start(100, { tid -> execute('set mouse=nv')})
autocmd FocusLost * set mouse=

set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*,*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls,*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*/dist/*,*/build/*,.idea/**,*DS_Store*,*/coverage/*,*/.git/*,*/package-lock.json,*/yarn.lock,*/go.sum

if executable('rg')
  set grepprg=rg\ --no-heading\ --vimgrep\ --smart-case\ --hidden
  set grepformat=%f:%l:%c:%m
endif

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=21

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
set smoothscroll

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

" https://github.com/luukvbaal/stabilize.nvim (it's stabilize, not stablize ajit)
" set splitkeep=screen

nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l

tnoremap <A-h> <c-\><c-n><C-w>h
tnoremap <A-j> <c-\><c-n><C-w>j
tnoremap <A-k> <c-\><c-n><C-w>k
tnoremap <A-l> <c-\><c-n><C-w>l
tnoremap <A-[> <c-\><c-n>
" <A-r>0 to paste from 0 register to FZF Lua for example
tnoremap <expr> <A-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'

fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

call SetupCommandAlias("nt","tabnew")
" keeps cursor at same place when cloning the buffer in new tab
call SetupCommandAlias("bt","tab sb")
call SetupCommandAlias("rg","GrepLiteral")

" commenting because might not be needed anymore
" originally was write followed by edit, that's why `we` command
" call SetupCommandAlias("we","update \\| edit")

set nowrap
" https://stackoverflow.com/questions/13294489/make-vim-only-do-a-soft-word-wrap-not-hard-word-wrap
set linebreak

source ~/.config/nvim/mine/indent.vim

set jumpoptions+=stack
" also see keepjumps command in help, useful in your scripts
" and changelist for general movements

" resolve realtive imports properly (in try) and
" prompt to create it if it's not present (in catch)
" from https://stackoverflow.com/a/29068665/7683365
function! Gf()
  let l:filepath = expand('<cfile>')
  let l:curr_buf_path = expand("%:p:h")
  let l:fullpath = ''

  try
    if l:filepath[0:len('./')-1] ==# './' || l:filepath[0:len('../')-1] ==# '../'
      " there is :h simplify() as well, though not applicable here
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

" needed so that LSP servers can properly hook into the files
" this seems to be not needed by typescript LSP anymore
" I'll enable it if it is reqd.
augroup auto_create_on_edit
  autocmd!
  "" you might need to `:edit` afterwards to re-attach LSP
  " autocmd BufNewFile * silent! :write | :edit
  "" but still, try this first:
  " autocmd BufNewFile * silent! :write
augroup END

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
      let stdin = join(lines, "\n")
      let output = system(cmd, stdin)
      let output = split(output, "\n")
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
" Eg. :Redir g=term-to-search

augroup highlight_yank
  autocmd!
  autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank {higroup="Visual", timeout=250}
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
  call setreg(a:regname, trim(l:reg_val) . "\n", "c")
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
local function buf_for_file()
  local has_path = vim.fn.expand('%:p') ~= ''
  local is_normal_buf = vim.api.nvim_eval('&buftype') == ''
  local file_exists_on_disk = vim.fn.filereadable(vim.fn.expand('%')) == 1
  if has_path and is_normal_buf and not file_exists_on_disk then
    return '🚫'
  end
  return ''
end

require('lualine').setup({
  options = {
    section_separators = '',
    icons_enabled = false,
  },
  sections = {
    lualine_b = {'diagnostics'},
    lualine_c = {'filename', buf_for_file},
    lualine_x = {"require'nvim-lightbulb'.get_status_text()", 'filetype'},
  },
  inactive_sections = {
    lualine_c = {'filename', buf_for_file},
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

" for completion
set completeopt=menu,menuone,noselect
set pumheight=8

autocmd BufRead,BufNewFile */node_modules/* lua vim.diagnostic.disable(0)
luafile ~/.config/nvim/mine/snippets.lua
lua require"mine.lsp"

command! EchoLineDiagnostics lua require('mine.lsp.diagnostics').echo_line_diagnostics()
command! PutErrorsInLocationList lua vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR })
command! PutDiagnosticsInLocationList lua vim.diagnostic.setloclist()
command! PutQfInLocationList cclose | call setloclist(0, [], ' ', {'items': get(getqflist({'items': 1}), 'items'), 'title': get(getqflist({'title': 1}), 'title')}) | lopen

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
nnoremap <leader>> :e %:.:h<c-z><space><bs>

lua require "mine.fzf"

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

nmap <leader>r <plug>(SubversiveSubstitute)
" looking for a xmap/vmap version for the above?
" `P` already does that. See `:h put-Visual-mode`
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
-- we have a way to extact range now https://github.com/neovim/neovim/issues/18533#issuecomment-1131471721
require"gitlinker".setup({ mappings = false })
vim.api.nvim_set_keymap('n', '<leader>fgx', '<cmd>lua require"gitlinker".get_buf_range_url("n", {add_current_line_on_normal_mode = false, action_callback = require"gitlinker.actions".open_in_browser})<cr>', {})
vim.api.nvim_set_keymap('n', '<leader>cgx', '<cmd>lua require"gitlinker".get_buf_range_url("n", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', {})
vim.api.nvim_set_keymap('v', '<leader>cgx', '<cmd>lua require"gitlinker".get_buf_range_url("v", {action_callback = require"gitlinker.actions".open_in_browser})<cr>', {})

local keymap = require("which-key").register
keymap({
  fgx = 'file remote URL',
  cgx = 'line remote URL',
  cgx = {'range remote URL', mode='v'},
}, {
  prefix = "<leader>"
})
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

-- an iterator that allows you to do `for v in values(some_array) do`
-- rather `for k, v in pairs(some_array) do`
function values(t)
  local i = 0
  return function() i = i + 1; return t[i] end
end

-- allows you to write vim.cmd(t('normal <C-e>'))
-- https://stackoverflow.com/a/69142336/7683365
function t(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
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
  " extra :r to remove 2nd extension like `.test` from `filename.test.ts` if it exists
  call feedkeys(expand('%:t:r:r'))
endfunction
imap <c-g>n <cmd>call <sid>PutFileName()<cr>

" unimpared like mapping for arglist
nnoremap [a <cmd>prev<cr><cmd>call repeat#set("[a")<cr>
nnoremap ]a <cmd>next<cr><cmd>call repeat#set("]a")<cr>

" unimpared like mapping for quickfix list
nnoremap [q <cmd>cprev<cr><cmd>call repeat#set("[q")<cr>
nnoremap ]q <cmd>cnext<cr><cmd>call repeat#set("]q")<cr>
nnoremap [Q <cmd>cpf<cr><cmd>call repeat#set("[Q")<cr>
nnoremap ]Q <cmd>cnf<cr><cmd>call repeat#set("]Q")<cr>

" unimpared like mapping for location list
nnoremap [l <cmd>lprev<cr><cmd>call repeat#set("[l")<cr>
nnoremap ]l <cmd>lnext<cr><cmd>call repeat#set("]l")<cr>
nnoremap [L <cmd>lpf<cr><cmd>call repeat#set("[L")<cr>
nnoremap ]L <cmd>lnf<cr><cmd>call repeat#set("]L")<cr>

" Unimpared like mapping for easy time-based step by step undo/redo.
" Useful for acting after `:earlier` and `:later`.
" `:later` w/o any arg works as `g+` and one can do `@:` and then `@@`
" afterwards but this is intuitive.
nnoremap g+ <cmd>norm! g+<cr><cmd>call repeat#set("g+")<cr>
nnoremap g- <cmd>norm! g-<cr><cmd>call repeat#set("g-")<cr>

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
let g:bettergrepprg = "rg --vimgrep --smart-case --hidden"

command! -nargs=+ GrepLiteral call GrepLiteral(<q-args>)
function! GrepLiteral(query, word = v:false)
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
  let l:flags = a:word ? " -w -F " : " -F "

  execute("Grep" . l:flags . "'" . l:query . "'")
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
nmap <leader>* <cmd>call GrepLiteral(expand('<cword>'), v:true)<cr>
vmap <leader>* :<c-u>execute "GrepLiteral " . GetVisualSelection()<cr>

" Search selected term
function! s:searchSelection()
  let l:selection = GetVisualSelection()
  " from https://vi.stackexchange.com/a/17474
  let @/='\V'.escape(l:selection, '\\')
  call searchlist#AddEntry()
endfunction
xnoremap * :<c-u>call <sid>searchSelection()<cr>n

" do exact word match
nmap <M-/> /\V\C\<\><left><left>
" search within a selection. See "Searching with / and ?" of https://vim.fandom.com/wiki/Search_and_replace_in_a_visual_selection
vmap <leader>/ <Esc>/\%V
" substitute within a selection
vmap <leader>? <Esc>:s/\%V

" nmap <leader>/ <plug>(esearch)
" map  <leader>? <plug>(operator-esearch-prefill)
" let g:esearch = {}
" let g:esearch.root_markers = g:root_markers

lua <<EOF
-- local vtext = {prefix = "⍿ ⚇  ◌ ", spacing = 5}
local vtext = {prefix = " ⚇ "}
vim.diagnostic.config({ virtual_text = vtext, severity_sort = true, underline = false })

local function toggle_diagnostic()
  local current = vim.diagnostic.config()
  -- short circuiting to toggle between false and somevalue
  vim.diagnostic.config({ virtual_text = (not current.virtual_text) and vtext })
end

local keymap = require("which-key").register
keymap({
    ["`"] = { "<cmd>e $MYVIMRC<cr>", "edit vimrc" },
    a = { "<c-^>", "alt buffer" },
    s = { "<cmd>FzfLua buffers<cr>", "switch to buffer" },
    ["'"] = { "<cmd>Telescope resume<cr>", "resume search" },
    t = {
      name = "toggle",
      -- if offscreen
      ["%"] = { "<cmd>TSContextDisable<cr><cmd>MatchupPairPopupToggle<cr>", "matching pair" },
      -- if offscreen
      c = { "<cmd>MatchupPairPopupDisable<cr><cmd>TSContextToggle<cr>", "code context" },
      d = { toggle_diagnostic, "inline diagnostics" },
      ["1"] = { "<cmd>tabdo windo set relativenumber!<cr>", "relative number" },
    },
    w = {
      name = "workspace",
      m  = { "<cmd>Telescope marks<cr>", "marks" },
      t  = { "<cmd>FzfLua tagstack<cr>", "tagstack" },
    },
    f = {
      name = "file",
      s  = { "<cmd>FzfLua btags<cr>", "symbols" },
      ["/"] = {"<cmd>FzfLua grep_curbuf<cr>", "search buffer"},
      -- https://github.com/ibhagwan/fzf-lua/blob/4707adc1ec9c5019590f6070ce578f68ed3a085c/lua/fzf-lua/providers/oldfiles.lua#L16
      -- current session's oldfiles aren't shown by default
      o  = { "<cmd>FzfLua oldfiles previewer=false include_current_session=true<cr>", "old files" },
      u  = { ":undolist<CR>:u<Space>", "undo list" },
      l = { ":call cursor()<left>", "goto line", silent=false },
      --  indent file without leaving cursor pos
      -- from https://stackoverflow.com/a/20110045/7683365
      ["="] = {'<cmd>let b:PlugView=winsaveview()<cr>gg=G<cmd>call winrestview(b:PlugView)<cr>', "format file" },
      y = {
        name = "yank",
        p  = { '<cmd>let @" = expand("%")<cr>', "path" },
        P  = { '<cmd>let @+ = expand("%")<cr>', "path to clipboard" },
        n  = { '<cmd>let @" = expand("%:t")<cr>', "name" },
        N  = { '<cmd>let @+ = expand("%:t")<cr>', "name to clipboard" },
      },
    },
    ["<space>"] = { "<cmd>FzfLua lsp_live_workspace_symbols<cr>", "find symbol" },
    ["/"] = {
      name = "live grep",
      ["/"] = { "<cmd>FzfLua live_grep<cr>", "whole project" },
      ["."] = { "<cmd>FzfLua live_grep cwd=%:h<cr>", "current folder" },
    }, 
    e  = { "<cmd>FzfLua files previewer=false<cr>", "find files" },
    [">"] = { ":edit in buffer dir" },
  }, {
    prefix = "<leader>",
  })
EOF

nnoremap _ <cmd>Neotree current toggle reveal<cr>
" opening file while on neo-tree doesn't make me do g;
" cursorline is not hihglighting in rasmus.nvim
" autocmd Filetype neo-tree setlocal cursorline

lua <<EOF
-- require('neogen').setup {}

require"bqf".setup {
  preview = {
    win_height = 999,
    border_chars = {'', '', '', '', '', '', '', '', ''},
    winblend = 0,
  }
}
EOF

" quick horizontal find
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
" Quick scope (horizontal navigation using find) token colors
" highlight QuickScopePrimary guifg='#6bdeba' gui=underline ctermfg=81
highlight QuickScopePrimary guifg='#6ade93' gui=underline ctermfg=81
highlight QuickScopeSecondary guifg='#ffa9d5' gui=underline ctermfg=81

let g:rooter_patterns = ['!^node_modules'] + g:root_markers

" what is the point of saving blank (empty) windows?
set sessionoptions-=blank
set sessionoptions+=winpos,terminal

autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb({sign = { enabled = false }, status_text = { enabled = true }})

" runs command on cursor line and replaces the line with shell output
nmap <leader>! yyp!!$SHELL<CR>

nnoremap <cr> <cmd>update<cr>
" ref. the line below `:h :wqa` to understand what it does
call SetupCommandAlias("x","confirm xall")
" incase :x fails; for eg. I have an modifed buffer which is not attached to a file, this will help me to jump to that file
nnoremap <F4> <cmd>qa<cr>

let g:interestingWordsGUIColors =["#ffa724", "#aeee00", "#8cffba", "#b88853", "#ff9eb8", "#ff2c4b"]
let g:interestingWordsDefaultMappings = 0
nnoremap <silent> <leader>m :call InterestingWords('n')<cr>
vnoremap <silent> <leader>m :call InterestingWords('v')<cr>
nnoremap <silent> <leader>M :call UncolorAllWords()<cr>
" Somehow results in hiding [3/34] that appears at bottom right at command line:
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
  " yep, system and user defined functions can be run through expression
  " register too https://vimeo.com/4446843
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

cmap <c-j> <Plug>CmdlineCompleteForward
cmap <c-k> <Plug>CmdlineCompleteBackward

" copy to register `a` for example (useful to append stuff using `A` later
" when deleting)
nmap <leader>" :let @a=@"<left><left><left>

" place current line to top using c-h while in insert mode
imap <c-h> <c-o>zt
" place cursor to the end
imap <c-;> <c-o>$

" to get element highlight capture...
" for treesitter, there's
" https://github.com/nvim-treesitter/nvim-treesitter/issues/94#issuecomment-780010595
" and for vim we have
" https://github.com/embark-theme/vim/issues/37#issuecomment-824196634

" keep the current buffer and clean the rest from buffer list
function! <SID>Bonly()
  let l:modified_buffers = len(filter(getbufinfo(), 'v:val.changed == 1'))
  let l:is_current_buffer_modified = getbufinfo('%')[0].changed

  " this weird logic is needed to remove the rest of the buffers 
  " even though the current one is modified

  if l:modified_buffers >= 2 || (l:modified_buffers == 1 && !l:is_current_buffer_modified)
    echo "Can't clean rest of the buffers as few of them are modified"
  else
    silent! %bd
    if !l:is_current_buffer_modified
      exec "normal \<C-o>"
      silent! bd#
    endif
  endif
endfun
command! Bonly call s:Bonly()

let g:neo_tree_remove_legacy_commands = 1

lua <<EOF
local commands = require('neo-tree.sources.common.commands')

require"neo-tree".setup({
  enable_git_status = false,
  enable_diagnostics = false,
  use_default_mappings = false,
  window = {
    mappings = {
      -- make j/k behave like j$B and k$B respectively, and do on filetype enter $B
      ["q"] = function(args)
        commands.close_window(args)
        local altbufnum = vim.w.neo_tree_before_open_alternate_buffer
        if altbufnum ~= -1 then
          vim.fn.setreg('#', altbufnum)
        end
      end,
      ["R"] = "refresh",
      -- ["<bs>"] = "navigate_up",
      -- ["."] = "set_root",
      ["l"] = "open",
      ["<cr>"] = "open",
      ["h"] = "close_node",
      ["_"] = "close_all_nodes",
      ["a"] = "add",
      ["A"] = "add_directory",
      ["r"] = "rename",
      ["d"] = "delete",
      ["x"] = "cut_to_clipboard",
      ["c"] = "copy_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["o"] = "toggle_preview",
      -- vim.cmd(t('normal <c-w>p'))
      -- vim.cmd('edit ' .. relative_path)
    },
  },
  default_component_configs = {
    container = {
      enable_character_fade = false
    },
    icon = {
      folder_closed = "🗀 ",
      folder_open = "🗁 ",
      folder_empty = "📂",
      default = " ·",
    },
  },
  filesystem = {
    hijack_netrw_behavior = 'open_current',
    bind_to_cwd = false,
    filtered_items = {
      hide_gitignored = false,
      hide_dotfiles = false,
      never_show = {
        ".git",
        "node_modules",
        "tags",
      }
    }
  },
  event_handlers = {
    {
      event = "neo_tree_buffer_enter",
      handler = function(args)
        vim.cmd [[
          setlocal number relativenumber
        ]]
      end,
    },
    {
      event = "neo_tree_window_before_open",
      handler = function(args)
        vim.w.neo_tree_before_open_visible_buffer = vim.fn.bufnr('%')
        vim.w.neo_tree_before_open_alternate_buffer = vim.fn.bufnr('#')
      end,
    },
    {
      event = "file_opened",
      handler = function(args)
        vim.fn.setreg('#', vim.w.neo_tree_before_open_visible_buffer)
        commands.close_window(args)
      end,
    }
  }
})
EOF

lua <<EOF
require("neodim").setup({
  alpha = 0.6,
  blend_color = "#161821", -- matches current theme's bg (Normal highlight guibg)
  hide = {signs = false},
  update_in_insert = {enable = false}
})
EOF

let g:indent_blankline_enabled = v:false
let g:indent_blankline_show_first_indent_level = v:false

" TODO implement `:argdedupe` https://vimhelp.org/editing.txt.html#%3Aargdedupe

let g:searchlist_maps = "search_only"
nnoremap <silent> g/ :<C-u>call searchlist#JumpBackwards()<cr>

lua require("true-zen").setup({ integrations = { lualine = true } })

" only added to remove alphabetical cross at the right of the tab bar
if exists("+showtabline")
  function MyTabLine()
    let s = ''
    let t = tabpagenr()
    let i = 1
    while i <= tabpagenr('$')
      let buflist = tabpagebuflist(i)
      let winnr = tabpagewinnr(i)
      let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
      let s .= ' %*'
      let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
      let file = bufname(buflist[winnr - 1])
      let file = fnamemodify(file, ':p:t')
      if file == ''
        let file = '[No Name]'
      endif
      let s .= file
      let s .= " "
      let i = i + 1
    endwhile
    let s .= '%T%#TabLineFill#%='
    return s
  endfunction
  set stal=1
  set tabline=%!MyTabLine()
endif

" -------------- juggle ------------------

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

" nnoremap <leader>j <cmd>Juggle<cr>

" ------------- don't center line on switching buffer ----------------
" from https://vim.fandom.com/wiki/Avoid_scrolling_when_switch_buffers

" Save current view settings on a per-window, per-buffer basis.
function! AutoSaveWinView()
    if !exists("w:SavedBufView")
        let w:SavedBufView = {}
    endif
    let w:SavedBufView[bufnr("%")] = winsaveview()
endfunction

" Restore current view settings.
function! AutoRestoreWinView()
    let buf = bufnr("%")
    if exists("w:SavedBufView") && has_key(w:SavedBufView, buf)
        let v = winsaveview()
        let atStartOfFile = v.lnum == 1 && v.col == 0
        if atStartOfFile && !&diff
            call winrestview(w:SavedBufView[buf])
        endif
        unlet w:SavedBufView[buf]
    endif
endfunction

" When switching buffers, preserve window view.
if v:version >= 700
    autocmd BufLeave * call AutoSaveWinView()
    autocmd BufEnter * call AutoRestoreWinView()
endif

" -------------------------
