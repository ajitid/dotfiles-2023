" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
" call plug#begin(stdpath('data') . '/plugged')

" luafile % or source % can reload that file as well
Plug 'famiu/nvim-reload'

Plug 'antoinemadec/FixCursorHold.nvim'

Plug 'farmergreg/vim-lastplace'

" Better Syntax Support
" Plug 'sheerun/vim-polyglot'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" all hail fzf
Plug 'junegunn/fzf'
" Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-repeat'

" https://www.reddit.com/r/vim/comments/nlvrhd/vimmers_of_reddit_whats_an_unknown_tip_that_has/gzlr9n7/
Plug 'lambdalisue/suda.vim'
" There are SudoEdit and SudoWrite commands already in tpope/vim-eunuch
" to use enunch one, use export SUDO_ASKPASS=/usr/lib/ssh/x11-ssh-askpass
" and install it using sudo apt-get install ssh-askpass
" ^ above installation might not be needed, try checking if `x11-ssh-askpass`
" autocompletes first. It can be manually executed using `ssh-askpass`
" for more info see
" https://unix.stackexchange.com/questions/83986/tell-ssh-to-use-a-graphical-prompt-for-key-passphrase
"
" see https://github.com/chrisbra/SudoEdit.vim 
" also see
" https://www.reddit.com/r/vim/comments/4b71o5/vim_automatic_open_readonly_file_with_sudo/d16s4bb/

" Automatically create pairing for '(' '[' '{'
Plug 'windwp/nvim-autopairs'

" LSP
Plug 'neovim/nvim-lspconfig'
Plug 'simrat39/rust-tools.nvim'

" Required for telescope 
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'fhill2/telescope-ultisnips.nvim'

Plug 'georgewitteman/vim-fish'

" [doesn't works the way I want it to] Frecency over MRU
" Plug 'tami5/sql.nvim'
" Plug 'nvim-telescope/telescope-frecency.nvim'
" also see https://github.com/vijaymarupudi/nvim-fzf and check if it can be
" used over telescope-fzy-native

" Gives UI actions to LSP
Plug 'ray-x/lsp_signature.nvim'

" Completion using LSP
Plug 'hrsh7th/nvim-compe'
Plug 'SirVer/ultisnips'

" icons for lsp symbols
" Plug 'onsails/lspkind-nvim'

" Plug 'co1ncidence/mountaineer.vim'

Plug 'arzg/vim-substrata'
Plug '~/nvimfiles/substratum'

" Unix file/dir shell commands
Plug 'tpope/vim-eunuch'

" Surround/change text with quotes, brackets or tags
Plug 'machakann/vim-sandwich'

" Folding using LSP
" Plug 'pierreglaser/folding-nvim'

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
" Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
" ^ undo tree doesn't has search or a preview mode
" see https://github.com/mbbill/undotree/issues/48
" also on `:q` on Undotree it removes the history
Plug 'simnalamburt/vim-mundo', {'on': 'MundoToggle'}

" Auto-correct your common mistakes, preserve case while substitution, and
" change case of words
Plug 'tpope/vim-abolish'

" color highlighter 
Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

Plug 'williamboman/nvim-lsp-installer'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'

Plug 'wellle/context.vim'

Plug 'tpope/vim-speeddating'
" TODO CtrlXA and splitjoin can be replaced by https://github.com/AndrewRadev/switch.vim
" On the contrary, splitjoin comes w/ a lot of options so we can keep CtrlXA +
" splitjoin combo, esp. that CtrlXA can magically update Roman numberals
" correctly. However switch.vim's regex matching is still could be the reason
" to prefer it over. more eg:
" https://github.com/AndrewRadev/switch.vim/issues/70
" https://github.com/AndrewRadev/switch.vim/wiki/React-props
Plug 'Konfekt/vim-CtrlXA'
Plug 'AndrewRadev/splitjoin.vim'

" TODO https://github.com/andrewRadev/deleft.vim
" ^ doesn't work if <Button> tag spans across lines to accomodate attributes
" (emmet remove tag could be helpful here)
" andymass/vim-matchup ain't perfect either, it breaks on that <Button> case

Plug 'mhinz/vim-rfc', { 'on' : 'RFC' }

Plug 'tpope/vim-obsession'
" commented Plug 'embear/vim-localvimrc' as using ->
Plug 'ii14/exrc.vim'
" commented as using own function:
" Plug 'tpope/vim-projectionist'

Plug 'ajitid/formatter.nvim', { 'branch': 'modifications-zlksnk' }

" visual mode * or # search
Plug 'ajitid/vim-visual-star-search', { 'branch': 'modifications-zlksnk' }
Plug 'ajitid/vim-bettergrep', { 'branch': 'modifications-zlksnk' }
" optional req fzf:
Plug 'kevinhwang91/nvim-bqf'
" ^ TODO it pollutes oldfiles https://github.com/kevinhwang91/nvim-bqf/issues/11

" TODO look at these
" Plug 'lukas-reineke/indent-blankline.nvim', { 'branch': 'lua' }
" Plug 'brooth/far.vim'
" and
" https://old.reddit.com/r/vim/comments/n2yymu/vimpeculiar_making_quick_multiline_edits_in_vim/

" TODO read https://www.reddit.com/r/vim/comments/adsqnx/favorite_custom_text_objects/edjw792/
Plug 'tommcdo/vim-exchange'
Plug 'svermeulen/vim-subversive'
Plug 'kana/vim-textobj-user'
Plug 'sgur/vim-textobj-parameter'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'tommcdo/vim-nowchangethat'

" more selection operations, or more inuitive ones {{{

" give the power of motions to text objects
" Plug 'tommcdo/vim-ninja-feet' << disabling this until
" https://github.com/tommcdo/vim-ninja-feet/pull/9 is merged
" Plug 'AdnoC/vim-ninja-feet', {'branch': 'fix-multiline-to-eol'}
" commented as it was overriding ]i and [i motions
" also for inner delete, d]} or 2d]} can basically do the same thing
" there is also search followed by <c-g> (w/o pressing enter after search)

" expand/shrink selection
" Plug 'gcmt/wildfire.vim'
" also see
" https://github.com/nvim-treesitter/nvim-treesitter#incremental-selection
" and https://news.ycombinator.com/item?id=27292237
" ^^ now i think doing di( and then dot repeat it would be much faster anyway
" and prefixing with number like 2di{

" }}}

Plug 'bfredl/nvim-miniyank'

" OSC52 (and maybe PASTE64) yank: https://github.com/ojroques/vim-oscyank
" ^ useful on an ssh-ed machine, and it seems like it can work w/o X forwarding:
" https://www.reddit.com/r/vim/comments/k1ydpn/a_guide_on_how_to_copy_text_from_anywhere/
" more at https://chromium.googlesource.com/apps/libapps/+/master/hterm/etc/osc52.vim
" --------
" X forwarding settings, if required, on guest and remote machine https://gist.github.com/habamax/75c75e5b590357709a11feb0def99072

" dir lister
Plug 'tamago324/lir.nvim'

" peek line
" commented as it breaks working of mapping <cmd>ls<cr>:b<space>
" see https://github.com/nacro90/numb.nvim/pull/18
" Plug 'nacro90/numb.nvim'

" create dir on file save
Plug 'pbrisbin/vim-mkdir'

" highlight search on demand
Plug 'romainl/vim-cool'

" sneaky
Plug 'justinmk/vim-sneak'

Plug 'ajitid/vim-repo-edit', {'branch': 'modifications-zlksnk'}

Plug 'junegunn/vim-easy-align'

" DISABLED ------------------------------------

" Plug 'markonm/traces.vim'

" Plug 'tweekmonster/startuptime.vim', { 'on': 'StartupTime' }

" Plug 'tommcdo/vim-lion' <- intuitive for basic use case
" using the below one instead of the above

" Plug 'kana/vim-textobj-indent'

" Plug 'junegunn/goyo.vim', { 'on' : 'Goyo' }
" there is also folke/zen-mode.nvim

" Plug 'gcmt/taboo.vim'

" check if mkdx can handle syntax highlhight, so I might then not need
" vim-gfm-syntax
" Plug 'rhysd/vim-gfm-syntax'
" Plug 'SidOfc/mkdx'

" subcommand mode
" Plug 'tomtom/tinykeymap_vim'

" Plug 'kosayoda/nvim-lightbulb'

" Plug 'ThePrimeagen/harpoon'

" Plug 'tpope/vim-fugitive'
" " for GitHub
" Plug 'tpope/vim-rhubarb'
" " for BitBucket
" Plug 'tommcdo/vim-fubitive'
" Plug 'tommcdo/vim-fugitive-blame-ext'
" ------ or --------
" Plug 'sindrets/diffview.nvim'
" TimUntersberger/neogit
" lewis6991/gitsigns.nvim

" ---------------------------------------------

call plug#end()