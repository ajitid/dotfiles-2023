local saga = require 'lspsaga'

saga.init_lsp_saga {
	error_sign = '🔥',
	warn_sign = '🚧',
	code_action_icon = '💡',
	code_action_prompt = {
		virtual_text = false
	},
	code_action_keys = {
		quit = '<esc>',
	},
	hint_sign = '🌿',
	dianostic_header_icon = "👀 "
}

-- removes background color for lightbulb which appears at right of code
-- vim.cmd [[ highlight link LspSagaLightBulb Special ]]

-- hide error and warning from gutter
-- vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = "LspDiagnosticsDefaultWarning"})
-- ^ only this one and err and warn signs were commented

-- vim.fn.sign_define("LspDiagnosticsSignWarning", {text = "", numhl = ""})
-- vim.fn.sign_define("LspDiagnosticsSignError", {text = "", numhl = ""})

