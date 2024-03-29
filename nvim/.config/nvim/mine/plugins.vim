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
Plug 'yorickpeterse/nvim-pqf'
" hey, sensible (n)vim already tries to make `Y` consistent, why not `cw`
Plug 'ap/vim-you-keep-using-that-word'

" slightly intelligent vim
Plug 'tpope/vim-sleuth'

Plug 'airblade/vim-rooter'
Plug 'tpope/vim-obsession'
" conditionally load a plugin on the basis or arguments passed
" if index(v:argv, '-S') == -1

Plug 'idbrii/vim-focusclip'
Plug 'bogado/file-line'
Plug 'ajitid/vim-searchlist'

Plug 'nvim-lua/plenary.nvim'

" smort
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-treesitter/playground'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'

Plug 'zbirenbaum/neodim'
Plug 'ajitid/folding-nvim'
Plug 'lukas-reineke/indent-blankline.nvim'

Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/nvim-cmp'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" styling
Plug 'ajitid/no-clown-fiesta.nvim', {'branch': 'ajitid'}
Plug 'nvim-lualine/lualine.nvim'
" Plug 'https://gitlab.com/__tpb/monokai-pro.nvim'

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
Plug 'kana/vim-textobj-entire'
" TODO use nvim-ts-context-commentstring to update comment string for
" JavaScript based files
Plug 'glts/vim-textobj-comment'
Plug 'tommcdo/vim-nowchangethat'
" there's also https://github.com/RRethy/nvim-treesitter-textsubjects
" locking it to this hash until
" https://github.com/nvim-treesitter/nvim-treesitter-textobjects/issues/215 is
" resolved
Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'ajitid/gitlinker.nvim', {'branch': 'fix/mapping'}
Plug 'AndrewRadev/splitjoin.vim'
Plug 'folke/which-key.nvim'
Plug 'cohama/lexima.vim'
Plug 'andymass/vim-matchup'
Plug 'romgrk/nvim-treesitter-context'
Plug 'unblevable/quick-scope'
Plug 'stevearc/aerial.nvim'
Plug 'kosayoda/nvim-lightbulb'
Plug 'tpope/vim-abolish'
" see https://github.com/ajitid/dotfiles/blob/cd797dfa99eb094dc454886103f31d4bdb4eedda/archived/nvim-2021/.config/nvim/plugins.vim#L135
Plug 'Konfekt/vim-CtrlXA'
Plug 'lfv89/vim-interestingwords'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install' }
Plug 'Pocco81/true-zen.nvim'

" alt ways:
" - https://stackoverflow.com/a/42249534
" - https://stackoverflow.com/a/58768939/7683365
" Plug 'mzlogin/vim-markdown-toc'
" might not be needed anymore because marksman lsp also provides a code action
" for this

Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }
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

" https://github.com/jay-babu/mason-null-ls.nvim

" https://github.com/Shougo/echodoc.vim (emacs like eldoc) and
" auto command hold to show current var type in echo area w/o
" logging them in `:messages`

" Plug 'pacha/vem-tabline', https://github.com/nanozuki/tabby.nvim are similar
" https://github.com/tiagovla/scope.nvim/issues/2 + https://github.com/gcmt/taboo.vim is a good idea, albeit saving globals in sessionoptions isn't, which taboo asks for
" Plug 'vim-ctrlspace/vim-ctrlspace' and scope.nvim are similar
" I think integrating vim-ctrlspace into vem-tabline is also a good idea

" color highlight for tailwind https://old.reddit.com/r/neovim/comments/woyyrz/documentcolornvim_lspbased_colorizer_for_neovim/
" not checked if i can remove vim-hexokinase with it, also check why didn't i
" opted for https://github.com/ap/vim-css-color

" rust
" https://www.reddit.com/r/neovim/comments/ot33sz/rusttoolsnvim_now_supports_debugging/
" https://www.reddit.com/r/neovim/comments/whrbzg/setup_rusttools_for_astronvim/
" https://rsdlt.github.io/posts/rust-nvim-ide-guide-walkthrough-development-debug/

" anuvyklack/hydra.nvim
" Plug 'tomtom/tinykeymap_vim'
" https://github.com/kana/vim-submode
" https://github.com/kana/vim-arpeggio/
" https://github.com/tjdevries/stackmap.nvim/
call plug#end()

