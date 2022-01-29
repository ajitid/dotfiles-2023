require'nvim-treesitter.configs'.setup {
	context_commentstring = {
		enable = true,
		-- we are using vim-commentary so it isn't needed anyway
		enable_autocmd = false,
	}
}
