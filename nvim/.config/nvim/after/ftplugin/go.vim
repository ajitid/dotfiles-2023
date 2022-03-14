" from https://github.com/fatih/vim-go/blob/c1fc27a5ad95589558f3083b0ece9d4d8f74ab18/ftplugin/go/commands.vim
" -- cmd
command! -buffer -nargs=* -bang GoBuild call go#cmd#Build(<bang>0,<f-args>)
" command! -buffer -nargs=* -bang GoGenerate call go#cmd#Generate(<bang>0,<f-args>)

" -- tags
command! -buffer -nargs=* -range GoAddTags call go#tags#Add(<line1>, <line2>, <count>, <f-args>)
command! -buffer -nargs=* -range GoRemoveTags call go#tags#Remove(<line1>, <line2>, <count>, <f-args>)

" -- fillstruct
command! -buffer -nargs=0 GoFillStruct call go#fillstruct#FillStruct()

" -- impl
command! -buffer -nargs=* -complete=customlist,go#impl#Complete GoImpl call go#impl#Impl(<f-args>)
