" https://www.reddit.com/r/neovim/comments/lx4anr/autocmd_au_filetype_au_bufreadpre_etc_doesnt_work/
" TODO https://github.com/nvim-treesitter/nvim-treesitter/issues/1249
" ^ this line below would still be needed, just that it won't work as expected until
" the issue is fixed:
autocmd BufRead,BufNewFile tsconfig.json,rush.json set filetype=jsonc
