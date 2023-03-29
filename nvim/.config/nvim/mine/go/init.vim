source ~/.config/nvim/mine/go/config.vim
source ~/.config/nvim/mine/go/util.vim
source ~/.config/nvim/mine/go/path.vim
source ~/.config/nvim/mine/go/list.vim
source ~/.config/nvim/mine/go/job.vim
source ~/.config/nvim/mine/go/package.vim
" needs
" go install github.com/fatih/gomodifytags@latest
" docs at https://github.com/fatih/vim-go/blob/00c5f2dad170131c0c850dbf331d63ddf515116d/doc/vim-go.txt#L770-L816
" modify tags using g:go_addtags_transform, see https://github.com/fatih/vim-go/issues/1265#issuecomment-299694718
source ~/.config/nvim/mine/go/tags.vim
source ~/.config/nvim/mine/go/cmd.vim
" needs
" go install github.com/davidrjenni/reftools/cmd/fillstruct@latest
" ^ lsp code action only fills the topmost struct, that's why this pkg
" is still useful
source ~/.config/nvim/mine/go/fillstruct.vim
source ~/.config/nvim/mine/go/impl.vim
source ~/.config/nvim/mine/go/lint.vim
source ~/.config/nvim/mine/go/commands.vim

" so to install all go intelli-deps, do:
" ```shell
" go install golang.org/x/tools/gopls@latest
" go install github.com/fatih/gomodifytags@latest
" go install github.com/davidrjenni/reftools/cmd/fillstruct@latest
" go install golang.org/x/tools/cmd/goimports@latest
" go install github.com/kisielk/errcheck@latest
" ```
