lua << EOF
function _G:StartyHeader()
	local padding_left = "    "
	local header = vim.api.nvim_eval("fnamemodify(FindRootDirectory(), ':t')")
	if(header == "") then
		local cwd = vim.api.nvim_eval("fnamemodify(getcwd(), ':t')")
		return padding_left .. cwd .." (doesn't look like a project)"
	end
	return padding_left .. header
end
EOF

let g:startify_custom_header = [v:lua.StartyHeader()]
