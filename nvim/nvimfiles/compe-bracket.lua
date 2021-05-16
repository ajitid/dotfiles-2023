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

Util.check_surroundings = function()
	local col = vim.fn.col('.')
	local line = vim.fn.getline('.')
	local prev_char = line:sub(col - 1, col - 1)
	local next_char = line:sub(col, col)
	-- from https://github.com/hrsh7th/nvim-compe/issues/106#issuecomment-770419258
	-- [|] -> [ | ] when you press space
	local pattern = '[%{|%}|%[|%]|%(|%)]'

	if prev_char:match(pattern) and next_char:match(pattern) then
		return true
	else
		return false
	end
end

Util.insert_space = function()
	local is_char_present = Util.check_surroundings()

	if is_char_present then
		return vim.api.nvim_replace_termcodes("  <Left>", true, false, true)
	end

	return " "
end

remap("i", "<Space>", "v:lua.Util.insert_space()", { expr = true, noremap = true })

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
