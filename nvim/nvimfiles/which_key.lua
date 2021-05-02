local wk = require("which-key")

wk.setup {
	triggers = {"<leader>"},
}

wk.register({
	f = {
		name = "find",
		f = {"<cmd>lua require('telescope.builtin').find_files({hidden = true})<cr>", "files"},
		b = {"<cmd>lua require('telescope.builtin').buffers({show_all_buffers = true})<cr>", "buffers"},
		h = {"<cmd>lua require('telescope.builtin').help_tags()<cr>", "vim and plugins help tags"},
		--								{shorten_path = true} can go here ↓
		o = {"<cmd>lua require('telescope.builtin').oldfiles()<cr>", "previously opened files"},
		s = {"<cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>", "symbols in current file"},
		-- lua version https://github.com/nvim-telescope/telescope.nvim/issues/568#issuecomment-794340390
		S = {":Telescope lsp_workspace_symbols query=", "symbols in project", silent = false},
		-- TODO: ^ a live version is landing soon https://github.com/nvim-telescope/telescope.nvim/pull/705#issue-604246613
		r = {"<cmd>lua require('telescope.builtin').lsp_references()<cr>", "references of word under cursor"},
		c = {"<cmd>lua require('telescope.builtin').command_history()<cr>", "in command history"},
	},
	s = {
		name = "show",
		d = {"<cmd>Lspsaga hover_doc<CR>", "doc"},
		s = {"<cmd>Lspsaga signature_help<CR>", "signature"},
		e = {"<cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>", "diagnostics at cursor"},
	},
	i = {
		name = "intelligent",
		r = {"<cmd>Lspsaga rename<cr>"},
	},
	g = {
		name = "goto",
		d = {"<cmd>Telescope lsp_definitions<cr>", "definition of word under cursor"},
		l = {":call cursor()<left>", "location", silent = false},
	},
	t = {
		name = "toggle",
		-- nnoremap <silent><expr> <Leader>th (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
		-- same as below
		h = {"<cmd>set hlsearch!<CR>", "highlight"},
		u = {"<cmd>UndotreeToggle<cr>", "undo tree"},
	},
	m = {
		name = "vim config",
		f = {"<cmd>tabe $MYVIMRC<cr>", "open"},
		s = {"<cmd>source $MYVIMRC<cr>", "source"},
	},
	l = {"<cmd>noh<cr><cmd>echo ''<cr>", "clear search highlights and command area"},
	b = {"va{V", "make block selection"},
	S = {":S/<c-r>0//g<left><left>", "substitute", silent = false},
	-- switch to alternate file by pressing spacebar twice instead of using <c-^> (<c-6>)
	["<space>"] = {"<cmd>b#<cr>", "switch to alternate file"},
}, {prefix = "<leader>"})

wk.register({
	S = {":S/<c-r>0//g<left><left>", "substitute", silent = false},
}, {
	mode = "v"
})
