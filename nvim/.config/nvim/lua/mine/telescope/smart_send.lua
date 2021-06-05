local action_state = require("telescope.actions.state")
local actions = require('telescope.actions')

local entry_to_qf = function(entry)
  return {
    bufnr = entry.bufnr,
    filename = entry.filename,
    lnum = entry.lnum,
    col = entry.col,
    text = entry.text or entry.value.text or entry.value,
  }
end

local send_selected_to_qf = function(prompt_bufnr, mode)
  local picker = action_state.get_current_picker(prompt_bufnr)

  local qf_entries = {}
  for _, entry in ipairs(picker:get_multi_selection()) do
    table.insert(qf_entries, entry_to_qf(entry))
  end

  actions.close(prompt_bufnr)

  vim.fn.setqflist(qf_entries, mode)
end

local send_all_to_qf = function(prompt_bufnr, mode)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local manager = picker.manager

  local qf_entries = {}
  for entry in manager:iter() do
    table.insert(qf_entries, entry_to_qf(entry))
  end

  actions.close(prompt_bufnr)

  vim.fn.setqflist(qf_entries, mode)
end

local smart_send = function(prompt_bufnr, mode)
  local picker = action_state.get_current_picker(prompt_bufnr)
  if table.getn(picker:get_multi_selection()) > 0 then
    send_selected_to_qf(prompt_bufnr, mode)
  else
    send_all_to_qf(prompt_bufnr, mode)
  end

  vim.api.nvim_exec('copen', false)

  local count = vim.api.nvim_eval('len(getqflist())')
  print(count .. ' result(s) found.')
end

return smart_send
