" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
" call plug#begin(stdpath('data') . '/plugged')

" Better Syntax Support
" Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" all hail fzf
" Plug 'junegunn/fzf'

" Automatically create pairing for '(' '[' '{'
" Plug 'LunarWatcher/auto-pairs'
Plug 'Raimondi/delimitMate'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'

" Required for telescope 
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" [doesn't works the way I want it to] Frecency over MRU
" Plug 'tami5/sql.nvim'
" Plug 'nvim-telescope/telescope-frecency.nvim'
" also see https://github.com/vijaymarupudi/nvim-fzf and check if it can be
" used over telescope-fzy-native


" Gives UI actions to LSP
Plug 'glepnir/lspsaga.nvim'

" icons for lsp symbols
" Plug 'onsails/lspkind-nvim'

" Ayu theme maintained fork
" Plug 'Luxed/ayu-vim'

" Embark theme
" Plug 'embark-theme/vim', { 'as': 'embark' }
" Plug '~/nvimfiles/embark-tuned', {'as': 'embark'}

" Plug 'co1ncidence/mountaineer.vim'

Plug 'arzg/vim-substrata'
Plug '~/nvimfiles/substratum'

Plug 'junegunn/goyo.vim', { 'on' : 'Goyo' }

" Forest theme
" Plug 'sainnhe/everforest'

" Quick tree navigation
" Plug 'justinmk/vim-dirvish'
" Plug 'cocopon/vaffle.vim'
Plug 'zlksnk/vaffle.vim', { 'branch' : 'modifications-zlksnk' }

" Surround/change text with quotes, bracekts or tags
Plug 'machakann/vim-sandwich'

" Folding using LSP
" Plug 'pierreglaser/folding-nvim'

" Completion using LSP
Plug 'hrsh7th/nvim-compe'

" TextMate like snippets
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" Smooth scrolling
Plug 'psliwka/vim-smoothie'

" Crawl to root of project
Plug 'airblade/vim-rooter'

" Customize startup-screen
" Plug 'mhinz/vim-startify'

" statusline
Plug 'itchyny/lightline.vim'

" Linter
" does not reqiure any plugin to install, instead needs a go binary, see 'mattn/efm-langserver' on GitHub

" EditorConfig
Plug 'tpope/vim-sleuth'
Plug 'editorconfig/editorconfig-vim'

" leader key shortcuts info
" Plug 'liuchengxu/vim-which-key'
Plug 'folke/which-key.nvim'

" comment
Plug 'tpope/vim-commentary'
" Plug 'suy/vim-context-commentstring'
" Plug 'b3nj5m1n/kommentary'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" Unix file/dir shell commands
Plug 'tpope/vim-eunuch'

" highlights chars when you do [f]ind related commands
Plug 'unblevable/quick-scope'

" undo tree viz
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }

" Auto-correct your common mistakes, preserve case while substitution, and
" change case of words
Plug 'tpope/vim-abolish'
Plug 'markonm/traces.vim'

" color highlighter 
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

" visual mode * or # search
Plug 'bronson/vim-visual-star-search'

" preserve yank history
Plug 'svermeulen/vim-yoink'

" sneaky
Plug 'justinmk/vim-sneak'

" fns and shortcuts for qflist
" Plug 'romainl/vim-qf'
" Plug 'jremmen/vim-ripgrep'
Plug 'williamboman/nvim-lsp-installer'

" cool thing that i don't know how to use just yet
" Plug 'brooth/far.vim'

Plug 'tpope/vim-obsession'
" ^ have found obsession to be the most predictable
" Plug 'rmagatti/auto-session'
" Plug 'rmagatti/session-lens'

Plug 'machakann/vim-swap'
Plug 'wellle/context.vim'
Plug 'embear/vim-localvimrc'
Plug 'rmagatti/alternate-toggler'
Plug 'mhinz/vim-rfc', { 'on' : 'RFC' }
Plug 'tpope/vim-projectionist'
Plug 'mhartington/formatter.nvim'

Plug 'ray-x/lsp_signature.nvim'

Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }

" peek line
Plug 'nacro90/numb.nvim'

Plug 'tommcdo/vim-lion'

" Plug 'lukas-reineke/indent-blankline.nvim', { 'branch': 'lua' }
call plug#end()
