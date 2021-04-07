require'nvim-lightbulb'.update_lightbulb {
	sign = {
		enabled = true,
		-- Priority of the gutter sign
		priority = 100,
	}
}

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]]
