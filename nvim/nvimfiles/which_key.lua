local wk = require("which-key")

wk.setup {
	triggers = {"<leader>"},
}

wk.register({
	f = {
		name = "find",
		f = {"<cmd>lua require('mine.telescope').find_files()<cr>", "files"},
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
		d = {"<cmd>lua vim.lsp.buf.hover()<CR>", "doc"},
		s = {"<cmd>lua vim.lsp.buf.signature_help()<CR>", "signature"},
	},
	i = {
		name = "intelligent",
		r = {"<cmd>lua vim.lsp.buf.rename()<cr>", "rename", silent=false}
		-- r = {":IRenameVariable ", "rename", silent=false},
	},
	g = {
		name = "goto",
		d = {"<cmd>Telescope lsp_definitions<cr>", "definition of word under cursor"},
	},
	t = {
		name = "toggle",
		-- nnoremap <silent><expr> <Leader>th (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"
		-- same as below
		-- h = {"<cmd>set hlsearch!<CR>", "highlight"},
		u = {"<cmd>UndotreeToggle<cr>", "undo tree"},
	},
	[";"] = {
		name = "vim config",
		f = {"<cmd>tabe $MYVIMRC<cr>", "open"},
		s = {"<cmd>source $MYVIMRC<cr><cmd>echo \"Vim config sourced\"<cr>", "source"},
		[";"] = {"<cmd>source $MYVIMRC<cr><cmd>echo \"Vim config sourced\"<cr>", "source"},
	},
	l = {"<cmd>noh<cr><cmd>echo ''<cr>", "clear search highlights and command area"},
	b = {"va{V", "make block selection"},
	-- S = {":S/<c-r>0//g<left><left>", "substitute", silent = false},
	-- S = "substitute word",
	-- switch to alternate file by pressing spacebar twice instead of using <c-^> (<c-6>)
	["<space>"] = {"<cmd>b#<cr>", "switch to alternate file"},
}, {prefix = "<leader>"})
