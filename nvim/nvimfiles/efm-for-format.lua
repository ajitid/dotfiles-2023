-- https://old.reddit.com/r/neovim/comments/jvisg5/lets_talk_formatting_again/
-- https://github.com/lukas-reineke/dotfiles/blob/59e73571f0ffa709c07879caeef1f8e72a0b9f99/vim/lua/lsp/formatting.lua
vim.lsp.handlers["textDocument/formatting"] = function(err, _, result, _, bufnr)
	if err ~= nil or result == nil then
		return
	end
	if not vim.api.nvim_buf_get_option(bufnr, "modified") then
		local view = vim.fn.winsaveview()
		vim.lsp.util.apply_text_edits(result, bufnr)
		vim.fn.winrestview(view)
		if bufnr == vim.api.nvim_get_current_buf() then
			vim.api.nvim_command("noautocmd :update")
		end
	end
end

local on_attach = function(client)
	if client.resolved_capabilities.document_formatting then
		vim.api.nvim_command [[augroup Format]]
		vim.api.nvim_command [[autocmd! * <buffer>]]
		vim.api.nvim_command [[autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()]]
		vim.api.nvim_command [[augroup END]]
	end
end

local prettier = require "efm/prettier"

lspconfig.efm.setup {
	on_attach = on_attach,
	init_options = {documentFormatting = true},
	settings = {
		rootMarkers = {"src/", ".git/"},
		languages = {
			-- ["="] = {misspell},
			-- vim = {vint},
			-- lua = {luafmt},
			-- go = {golint, goimports},
			-- python = {black, isort, flake8, mypy},
			typescript = {prettier, eslint},
			javascript = {prettier, eslint},
			typescriptreact = {prettier, eslint},
			javascriptreact = {prettier, eslint},
			-- yaml = {prettier},
			-- json = {prettier},
			-- html = {prettier},
			-- scss = {prettier},
			-- css = {prettier},
			-- markdown = {prettier},
			-- sh = {shellcheck},
			-- tf = {terraform}
		}
	}
}
