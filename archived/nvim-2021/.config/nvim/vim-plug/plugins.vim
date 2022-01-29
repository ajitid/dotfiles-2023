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

" Required for telescope 
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzy-native.nvim'

" [doesn't works the way I want it to] Frecency over MRU
" Plug 'tami5/sql.nvim'
" Plug 'nvim-telescope/telescope-frecency.nvim'
" also see https://github.com/vijaymarupudi/nvim-fzf and check if it can be
" used over telescope-fzy-native

" LSP
Plug 'neovim/nvim-lspconfig'

" Gives UI actions to LSP
Plug 'glepnir/lspsaga.nvim'

" icons for lsp symbols
Plug 'onsails/lspkind-nvim'

" Ayu theme maintained fork
" Plug 'Luxed/ayu-vim'

" Embark theme
" Plug 'embark-theme/vim', { 'as': 'embark' }
Plug '~/nvimfiles/embark-tuned', {'as': 'embark'}
Plug 'junegunn/goyo.vim'

" Forest theme
" Plug 'sainnhe/everforest'

" Quick tree navigation
Plug 'justinmk/vim-dirvish'

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
Plug 'mhinz/vim-startify'

" statusline
Plug 'itchyny/lightline.vim'

" Linter
" does not reqiure any plugin to install, instead needs a go binary, see 'mattn/efm-langserver' on GitHub

" EditorConfig
Plug 'tpope/vim-sleuth'
Plug 'editorconfig/editorconfig-vim'

" leader key shortcuts info
Plug 'liuchengxu/vim-which-key'

" comment
Plug 'tpope/vim-commentary'
Plug 'suy/vim-context-commentstring'

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

" Plug 'kosayoda/nvim-lightbulb'
Plug 'machakann/vim-swap'
Plug 'wellle/context.vim'
call plug#end()
