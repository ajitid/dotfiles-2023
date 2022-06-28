call plug#begin()
" apart from usuall gcc, build-essential, rg, fzf, fd you would need:
" - golang - for vim-hexokinase
" - yarn - for markdown-preview

" sane vim
" there's also https://github.com/windwp/nvim-projectconfig
Plug 'ii14/exrc.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'pbrisbin/vim-mkdir'
Plug 'romainl/vim-cool'
Plug 'https://gitlab.com/yorickpeterse/nvim-pqf.git'
" hey, sensible (n)vim already tries to make `Y` consistent, why not `cw`
Plug 'ap/vim-you-keep-using-that-word'

" slightly intelligent vim
Plug 'tpope/vim-sleuth'
Plug 'editorconfig/editorconfig-vim'

Plug 'airblade/vim-rooter'
Plug 'tpope/vim-obsession'
" conditionally load a plugin on the basis or arguments passed
" if index(v:argv, '-S') == -1

" styling
Plug 'kvrohit/rasmus.nvim'
Plug 'cocopon/iceberg.vim'
Plug 'nvim-lualine/lualine.nvim'

" smort
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Plug 'nvim-treesitter/playground'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'narutoxy/dim.lua'

Plug 'nvim-lua/plenary.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" others
Plug 'tpope/vim-eunuch'
Plug 'numToStr/Comment.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'ajitid/vim-bettergrep'
" see https://github.com/nvim-lua/wishlist/issues/9#issuecomment-1025085677
" and https://old.reddit.com/r/neovim/comments/oxl9pz/whats_the_recommended_way_to_handle_formatting/h7ndya2/
" before adding a formatter or a linter
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'b0o/schemastore.nvim'
Plug 'tpope/vim-repeat'
Plug 'machakann/vim-sandwich'
Plug 'rlane/pounce.nvim'
Plug 'junegunn/vim-easy-align'

" these are relevant and helpful
" https://stackoverflow.com/a/51962260/7683365
" https://www.reddit.com/r/vim/comments/7dv9as/how_to_edit_the_vim_quickfix_list/
Plug 'kevinhwang91/nvim-bqf'
Plug 'tommcdo/vim-exchange'
Plug 'svermeulen/vim-subversive'
Plug 'kana/vim-textobj-user'
Plug 'sgur/vim-textobj-parameter'
Plug 'Julian/vim-textobj-variable-segment'
" TODO use nvim-ts-context-commentstring to update comment string for
" JavaScript based files
Plug 'glts/vim-textobj-comment'
Plug 'tommcdo/vim-nowchangethat'
" there's also https://github.com/RRethy/nvim-treesitter-textsubjects
" locking it to this hash until
" https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/215 is
" resolved
Plug 'nvim-treesitter/nvim-treesitter-textobjects', {'commit': 'b00b344c0f5a0a458d6e66eb570cfb347ebf4c38'}
Plug 'ajitid/gitlinker.nvim', {'branch': 'fix/mapping'}
Plug 'AndrewRadev/splitjoin.vim'
Plug 'folke/which-key.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'andymass/vim-matchup'
Plug 'romgrk/nvim-treesitter-context'
Plug 'unblevable/quick-scope'
Plug 'stevearc/aerial.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'ray-x/lsp_signature.nvim'
Plug 'tpope/vim-abolish'
" see https://github.com/ajitid/dotfiles/blob/cd797dfa99eb094dc454886103f31d4bdb4eedda/archived/nvim-2021/.config/nvim/plugins.vim#L135
Plug 'Konfekt/vim-CtrlXA'
Plug 'lfv89/vim-interestingwords'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install' }

" alt ways:
" - https://stackoverflow.com/a/42249534
" - https://stackoverflow.com/a/58768939/7683365
" Plug 'mzlogin/vim-markdown-toc'
" might not be needed anymore because marksman lsp also provides a code action
" for this


Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
" cd ~; rm (fd -It f '^tags$')
Plug 'ludovicchabant/vim-gutentags'
Plug 'vim-scripts/CmdlineComplete'

Plug 'ibhagwan/fzf-lua', {'branch': 'main'}

Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'

"""""""" evaluate
" https://github.com/tommcdo/vim-ninja-feet
" https://www.reddit.com/r/vim/comments/22ggej/comment/cgmkz6b/?utm_source=share&utm_medium=web2x&context=3
" https://github.com/danymat/neogen
" Plug 'eugen0329/vim-esearch'
" trouble nvim + that plugin that doesn't move splits when folke/trouble.nvim

" anuvyklack/hydra.nvim
" Plug 'tomtom/tinykeymap_vim'
" https://github.com/kana/vim-submode
" https://github.com/kana/vim-arpeggio/
" https://github.com/tjdevries/stackmap.nvim/
call plug#end()

