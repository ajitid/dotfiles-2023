local npairs = require('nvim-autopairs')
local remap = vim.api.nvim_set_keymap

npairs.setup{
	break_line_filetype = nil, -- enable this rule for all filetypes
	pairs_map = {
		["'"] = "'",
		['"'] = '"',
		['('] = ')',
		['['] = ']',
		['{'] = '}',
		['`'] = '`',
	},
	disable_filetype = { "TelescopePrompt" },
	html_break_line_filetype = {
		'html' , 'vue' , 'typescriptreact' , 'svelte' , 'javascriptreact'
	},
	-- ignore alphanumeric, operators, quote, curly brace, and square bracket
	ignored_next_char = "[%w%.%+%-%=%/%,\"'{}%[%]]"
}

Util = {}

Util.trigger_completion = function()
	if vim.fn.pumvisible() ~= 0  then

		if vim.fn.complete_info()["selected"] ~= -1 then
			return vim.fn["compe#confirm"]()
		end

		vim.fn.nvim_select_popupmenu_item(0 , false , false ,{})
		return vim.fn["compe#confirm"]()
	end

	return npairs.check_break_line_char()
end

remap('i', '<CR>', 'v:lua.Util.trigger_completion()', { expr = true, silent = true })
