" from https://github.com/fatih/vim-go/blob/c1fc27a5ad95589558f3083b0ece9d4d8f74ab18/ftplugin/go/commands.vim

" -- cmd
autocmd FileType go command! -buffer -nargs=* -bang GoBuild call go#cmd#Build(<bang>0,<f-args>)
" command! -nargs=* -bang GoGenerate call go#cmd#Generate(<bang>0,<f-args>)

" -- tags
autocmd FileType go command! -buffer -nargs=* -range GoAddTags call go#tags#Add(<line1>, <line2>, <count>, <f-args>)
autocmd FileType go command! -buffer -nargs=* -range GoRemoveTags call go#tags#Remove(<line1>, <line2>, <count>, <f-args>)

" -- fillstruct
autocmd FileType go command! -buffer -nargs=0 GoFillStruct call go#fillstruct#FillStruct()
