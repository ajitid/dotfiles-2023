-- https://github.com/mhartington/formatter.nvim/issues/34
-- more at https://github.com/mhartington/formatter.nvim/issues/31#issuecomment-790815328
-- also seems like efm-langserver is better for formatting:
-- - https://github.com/fsouza/prettierd#editor-integration
-- - https://old.reddit.com/r/neovim/comments/jvisg5/lets_talk_formatting_again/

-- for prettier
-- exe = "npx prettier",
-- args = {vim.api.nvim_buf_get_name(0), "--stdin"},

local prettier = function()
	return {
		-- install from npm -> @fsouza/prettierd
		exe = "prettierd",
		args = {vim.api.nvim_buf_get_name(0)},
		stdin = true
	}
end

local rustfmt = function()
	return {
		exe = "rustfmt",
		args = {vim.api.nvim_buf_get_name(0)},
		stdin = false
	}
end

-- to save without format, use `:noa w`
-- also you can use `let b:formatter_skip_buf=1`

require('formatter').setup({
	logging = false,
	filetype = {
		typescript = { prettier },
		javascript = { prettier },
		typescriptreact = { prettier },
		javascriptreact = { prettier },
		json = { prettier },
		jsonc = { prettier },
		rust = { rustfmt }
	}
})

-- from https://vi.stackexchange.com/a/3971 <- reverted, but still useful
--
-- while this is what you want instead of BufWritePost
-- ```
-- autocmd BufWriteCmd *.ts,*.js,*.tsx,*.jsx,*.json,*.jsonc,*.rs FormatWrite
-- ```
-- it has its own issues, for eg, when LSP servers are not attached to newly
-- created TS file, save won't even work as formatter will fail. Another case is
-- when you switch to other buffer on save start, let's say to Telescope
-- it will try writing there (update: this point actually doesn't holds).
-- This plugin still has issue when saves are made, if on save start I move to another
-- buffer it will show modified as `:update` didn't ran on that buffer.
vim.api.nvim_exec([[
augroup FormatAutogroup
	autocmd!
	autocmd BufWritePost *.ts,*.js,*.tsx,*.jsx,*.json,*.jsonc,*.rs FormatWrite
augroup END
]], true)
