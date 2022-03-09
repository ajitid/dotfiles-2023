" from https://github.com/fatih/vim-go/blob/c1fc27a5ad95589558f3083b0ece9d4d8f74ab18/ftplugin/go/commands.vim

" -- tags
command! -nargs=* -range GoAddTags call go#tags#Add(<line1>, <line2>, <count>, <f-args>)
command! -nargs=* -range GoRemoveTags call go#tags#Remove(<line1>, <line2>, <count>, <f-args>)
