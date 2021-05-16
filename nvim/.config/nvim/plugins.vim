" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

" MAX 55 plugins

call plug#begin('~/.config/nvim/autoload/plugged')
" call plug#begin(stdpath('data') . '/plugged')

" Better Syntax Support
" Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" all hail fzf
Plug 'junegunn/fzf'

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

" Plug 'co1ncidence/mountaineer.vim'

Plug 'arzg/vim-substrata'
Plug '~/nvimfiles/substratum'

Plug 'junegunn/goyo.vim', { 'on' : 'Goyo' }

" Forest theme
" Plug 'sainnhe/everforest'

" Quick tree navigation
" Plug 'justinmk/vim-dirvish'
" Plug 'cocopon/vaffle.vim'
" Plug 'zlksnk/vaffle.vim', { 'branch' : 'modifications-zlksnk' }

" Unix file/dir shell commands
Plug 'tpope/vim-eunuch'

" Surround/change text with quotes, brackets or tags
Plug 'machakann/vim-sandwich'

" Folding using LSP
" Plug 'pierreglaser/folding-nvim'

" Completion using LSP
Plug 'hrsh7th/nvim-compe'

Plug 'SirVer/ultisnips'

" Smooth scrolling
Plug 'psliwka/vim-smoothie'

" Crawl to root of project
Plug 'airblade/vim-rooter'

" statusline
Plug 'itchyny/lightline.vim'

" Linter
" does not reqiure any plugin to install, instead needs a go binary, see 'mattn/efm-langserver' on GitHub

" EditorConfig
Plug 'tpope/vim-sleuth'
Plug 'editorconfig/editorconfig-vim'

" leader key shortcuts info
Plug 'folke/which-key.nvim'

" comment
Plug 'tpope/vim-commentary'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

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
Plug 'zlksnk/vim-visual-star-search', { 'branch': 'modifications-zlksnk' }

" preserve yank history
Plug 'svermeulen/vim-yoink'

" sneaky
Plug 'justinmk/vim-sneak'

Plug 'williamboman/nvim-lsp-installer'

Plug 'tpope/vim-obsession'

Plug 'wellle/context.vim'
Plug 'Konfekt/vim-CtrlXA'
Plug 'mhinz/vim-rfc', { 'on' : 'RFC' }

Plug 'embear/vim-localvimrc'
Plug 'tpope/vim-projectionist'

Plug 'mhartington/formatter.nvim'

Plug 'ray-x/lsp_signature.nvim'

Plug 'zlksnk/vim-bettergrep', { 'branch': 'modifications-zlksnk' }

" optional req fzf:
Plug 'kevinhwang91/nvim-bqf'
" ^ TODO it pollutes oldfiles https://github.com/kevinhwang91/nvim-bqf/issues/11

" TODO look at these
" Plug 'lukas-reineke/indent-blankline.nvim', { 'branch': 'lua' }
" Plug 'brooth/far.vim'
" and
" https://old.reddit.com/r/vim/comments/n2yymu/vimpeculiar_making_quick_multiline_edits_in_vim/

" TODO read https://www.reddit.com/r/vim/comments/adsqnx/favorite_custom_text_objects/edjw792/
Plug 'kana/vim-textobj-user'
Plug 'sgur/vim-textobj-parameter'
Plug 'Julian/vim-textobj-variable-segment'

Plug 'fhill2/telescope-ultisnips.nvim'

" OSC52 (and maybe PASTE64) yank: https://github.com/ojroques/vim-oscyank
" ^ useful on an ssh-ed machine, and it seems like it can work w/o X forwarding:
" https://www.reddit.com/r/vim/comments/k1ydpn/a_guide_on_how_to_copy_text_from_anywhere/
" more at https://chromium.googlesource.com/apps/libapps/+/master/hterm/etc/osc52.vim
" --------
" X forwarding settings, if required, on guest and remote machine https://gist.github.com/habamax/75c75e5b590357709a11feb0def99072


Plug 'tamago324/lir.nvim'

Plug 'tommcdo/vim-exchange'

" DISABLED ------------------------------------

" Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }

" peek line
" Plug 'nacro90/numb.nvim'

" Plug 'tommcdo/vim-lion' <- intuitive for basic use case
" using the below one instead of the above
" Plug 'junegunn/vim-easy-align'

" Plug 'kana/vim-textobj-indent'

" ---------------------------------------------

call plug#end()
