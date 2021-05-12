local lir = require'lir'
local actions = require'lir.actions'
local mark_actions = require 'lir.mark.actions'
local clipboard_actions = require'lir.clipboard.actions'

lir.setup {
	show_hidden_files = true,
	mappings = {
		['-']     = function()
			vim.cmd('Juggle')
			actions.quit()
			vim.cmd('edit .')
		end,
		['l']     = actions.edit,
		['<C-s>'] = actions.split,
		['<C-v>'] = actions.vsplit,
		['<C-t>'] = actions.tabedit,

		['h']     = actions.up,
		['q']     = function()
			vim.cmd('Juggle')
			actions.quit()
		end,
		['K']     = actions.mkdir,
		['N']     = actions.newfile,
		['R']     = actions.rename,
		['@']     = actions.cd,
		['Y']     = actions.yank_path,
		['.']     = actions.toggle_show_hidden,
		['D']     = actions.delete,

		['J'] = function()
			mark_actions.toggle_mark()
			vim.cmd('normal! j')
		end,
		['C'] = clipboard_actions.copy,
		['X'] = clipboard_actions.cut,
		['P'] = clipboard_actions.paste,
		-- put current path in cmd line
		['x'] = function()
			local current = lir.get_context():current()
			vim.cmd('call feedkeys(": ' .. current.fullpath .. '\\<Home>")')
		end,
	},
	float = {
		size_percentage = 0.5,
		winblend = 15,
		border = true,
		borderchars = {"" , "" , "" , "" , "" , "" , "", ""},

		-- -- If you want to use `shadow`, set `shadow` to `true`.
		-- -- Also, if you set shadow to true, the value of `borderchars` will be ignored.
		-- shadow = false,
	},
	hide_cursor = true,
}



-- use visual mode
function _G.LirSettings()
	vim.api.nvim_buf_set_keymap(0, 'x', 'J', ':<C-u>lua require"lir.mark.actions".toggle_mark("v")<CR>', {noremap = true, silent = true})

	-- echo cwd
	vim.api.nvim_echo({{vim.fn.expand('%:p'), 'Normal'}}, false, {})
end

vim.cmd [[augroup lir-settings]]
vim.cmd [[  autocmd!]]
vim.cmd [[  autocmd Filetype lir :lua LirSettings()]]
vim.cmd [[augroup END]]
