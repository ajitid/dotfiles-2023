call plug#begin()
" sane vim
" there's also https://github.com/windwp/nvim-projectconfig
Plug 'ii14/exrc.vim'
Plug 'antoinemadec/FixCursorHold.nvim'
Plug 'romainl/vim-cool'
Plug 'pbrisbin/vim-mkdir'
Plug 'https://gitlab.com/yorickpeterse/nvim-pqf.git'

" slightly intelligent vim
Plug 'tpope/vim-sleuth'
Plug 'editorconfig/editorconfig-vim'

Plug 'airblade/vim-rooter'
Plug 'tpope/vim-obsession'

" styling
Plug 'rktjmp/lush.nvim'
Plug 'mcchrish/zenbones.nvim'
Plug 'nvim-lualine/lualine.nvim'

" smort
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'

Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
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
Plug 'ajitid/vim-bettergrep', { 'branch': 'modifications-zlksnk' }
" see https://github.com/nvim-lua/wishlist/issues/9#issuecomment-1025085677
" and https://old.reddit.com/r/neovim/comments/oxl9pz/whats_the_recommended_way_to_handle_formatting/h7ndya2/
" before adding a formatter or a linter
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'b0o/schemastore.nvim'
Plug 'tpope/vim-repeat'
Plug 'machakann/vim-sandwich'
Plug 'rlane/pounce.nvim'
Plug 'junegunn/vim-easy-align'
Plug 'justinmk/vim-dirvish'
Plug 'kevinhwang91/nvim-bqf'
Plug 'tommcdo/vim-exchange'
Plug 'svermeulen/vim-subversive'
Plug 'kana/vim-textobj-user'
Plug 'sgur/vim-textobj-parameter'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'tommcdo/vim-nowchangethat'
" there's also https://github.com/RRethy/nvim-treesitter-textsubjects
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'ajitid/gitlinker.nvim', { 'branch': 'fix/respect-nil-mapping' }
Plug 'eugen0329/vim-esearch'
Plug 'AndrewRadev/splitjoin.vim'
" shifts the code too much
" Plug 'https://git.sr.ht/~whynothugo/lsp_lines.nvim'
Plug 'folke/which-key.nvim'
Plug 'windwp/nvim-autopairs'
Plug 'andymass/vim-matchup'
Plug 'natecraddock/telescope-zf-native.nvim'
Plug 'romgrk/nvim-treesitter-context'
Plug 'unblevable/quick-scope'
Plug 'stevearc/aerial.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'ray-x/lsp_signature.nvim'
Plug 'tpope/vim-abolish'
" see https://github.com/ajitid/dotfiles/blob/cd797dfa99eb094dc454886103f31d4bdb4eedda/archived/nvim-2021/.config/nvim/plugins.vim#L135
Plug 'Konfekt/vim-CtrlXA'

"""""""" evaluate
" Plug 'danymat/neogen'
" Plug 'jubnzv/virtual-types.nvim'
" subcommand mode
" Plug 'tomtom/tinykeymap_vim'
" https://github.com/tjdevries/stackmap.nvim/
call plug#end()
