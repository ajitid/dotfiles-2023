-- https://github.com/mhartington/formatter.nvim/issues/34
-- more at https://github.com/mhartington/formatter.nvim/issues/31#issuecomment-790815328
local prettier = function()
	return {
		-- install @fsouza/prettierd
		exe = "prettierd",
		args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
		stdin = true
	}
end

-- to save without format, use `:noa w`

require('formatter').setup({
	logging = false,
	filetype = {
		typescriptreact = { prettier },
		typescript = { prettier },
		javascriptreact = { prettier },
		javascript = { prettier },
		json = { prettier },
	}
})

-- from https://vi.stackexchange.com/a/3971 <- reverted, but still useful
vim.api.nvim_exec([[
augroup FormatAutogroup
	autocmd!
	autocmd BufWritePost *ts,*.tsx,*.js,*.jsx,*.json FormatWrite
augroup END
]], true)
