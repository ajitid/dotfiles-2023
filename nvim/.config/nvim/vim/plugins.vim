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
call plug#end()
