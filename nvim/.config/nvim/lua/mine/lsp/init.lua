local lsp,util,api = vim.lsp,vim.lsp.util,vim.api

local rename_variable = function(new_name)
  local params = util.make_position_params()
  local current_name = vim.fn.expand('<cword>')
  if not (new_name and #new_name > 0) or new_name == current_name then
    return
  end
  params.newName = new_name
  lsp.buf_request(0,'textDocument/rename', params)
end

return {
  rename_variable = rename_variable,
}

