call plug#begin()
" sane vim
Plug 'ii14/exrc.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'romainl/vim-cool'
Plug 'pbrisbin/vim-mkdir'

" slightly intelligent vim
Plug 'tpope/vim-sleuth'
Plug 'editorconfig/editorconfig-vim'

Plug 'farmergreg/vim-lastplace'
Plug 'airblade/vim-rooter'

" styling
Plug 'rebelot/kanagawa.nvim'
Plug 'nvim-lualine/lualine.nvim'

" smort
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" others
Plug 'tpope/vim-eunuch'
Plug 'j-hui/fidget.nvim'
Plug 'numToStr/Comment.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'onsails/lspkind-nvim'
Plug 'https://gitlab.com/yorickpeterse/nvim-pqf.git'
Plug 'romgrk/nvim-treesitter-context'
Plug 'ajitid/vim-bettergrep', { 'branch': 'modifications-zlksnk' }
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'b0o/schemastore.nvim'
Plug 'tpope/vim-repeat'
Plug 'machakann/vim-sandwich'
Plug 'rlane/pounce.nvim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-dirvish'
call plug#end()
