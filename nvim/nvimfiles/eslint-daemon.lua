local eslint = {
	lintCommand = "eslint_d -f compact --stdin --stdin-filename ${INPUT}",
	lintStdin = true,
	lintFormats = {"%f: line %l, col %c, %trror - %m", "%f: line %l, col %c, %tarning - %m"},
	lintIgnoreExitCode = true,
	formatCommand = "eslint_d --fix-to-stdout --stdin --stdin-filename=${INPUT}",
	formatStdin = true
}

local function eslint_config_exists()
	local eslintrc = vim.fn.glob(".eslintrc*", 0, 1)

	if not vim.tbl_isempty(eslintrc) then
		return true
	end

	if vim.fn.filereadable("package.json") then
		if vim.fn.json_decode(vim.fn.readfile("package.json"))["eslintConfig"] then
			return true
		end
	end

	return false
end


-- For linting https://phelipetls.github.io/posts/configuring-eslint-to-work-with-neovim-lsp/
-- newest config in this file has been diverted away a lot from the above link
lspconfig.efm.setup {
	init_options = {documentFormatting = true},
	root_dir = function()
		if not eslint_config_exists() then
			return nil
		end
		return vim.fn.getcwd()
	end,
	settings = {
		languages = {
			javascript = {eslint},
			javascriptreact = {eslint},
			["javascript.jsx"] = {eslint},
			typescript = {eslint},
			["typescript.tsx"] = {eslint},
			typescriptreact = {eslint}
		}
	},
	-- filetypes might be needed due to a bug https://github.com/mattn/efm-langserver/issues/92#issuecomment-764091242
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescript.tsx",
		"typescriptreact"
	},
}

