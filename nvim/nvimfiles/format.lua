-- https://github.com/mhartington/formatter.nvim/issues/34
-- more at https://github.com/mhartington/formatter.nvim/issues/31#issuecomment-790815328
local prettier = function()
	return {
		-- install from npm -> @fsouza/prettierd
		exe = "prettierd",
		args = {vim.api.nvim_buf_get_name(0)},
		stdin = true
	}
end

-- to save without format, use `:noa w`

require('formatter').setup({
	logging = false,
	filetype = {
		typescript = { prettier },
		javascript = { prettier },
		typescriptreact = { prettier },
		javascriptreact = { prettier },
		json = { prettier },
	}
})

-- from https://vi.stackexchange.com/a/3971 <- reverted, but still useful
vim.api.nvim_exec([[
augroup FormatAutogroup
	autocmd!
	autocmd BufWritePost *.ts,*.js,*.tsx,*.jsx,*.json FormatWrite
augroup END
]], true)
