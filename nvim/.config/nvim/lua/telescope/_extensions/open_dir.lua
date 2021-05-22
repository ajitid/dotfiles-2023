local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugins requires nvim-telescope/telescope.nvim")
end

local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local entry_display = require("telescope.pickers.entry_display")
local conf = require("telescope.config").values

local open_dir = function()
  local output_str = vim.api.nvim_exec('!fd -t d -c never', true)

  local output = vim.split(output_str, '\n')
  local result = {}

  -- first line in output is the cmd we entered so we need to ignore it,
  -- we also need to drop lines that are empty
  for i, v in ipairs(output) do
    if i == 1 or v == '' then
      goto skip_to_next
    end

    table.insert(result, v)

    ::skip_to_next::
  end

  local displayer = entry_display.create({
    separator = " ",
    items = { { remaining = true } },
  })

  local make_display = function(entry)
    return displayer({ entry.value })
  end

  pickers.new(opts, {
    prompt_title = "Open dir...",
    finder = finders.new_table({
      results = result,
      entry_maker = function(entry)
        return {
          value = entry,
          display = make_display,
          ordinal = entry
        }
      end,
    }),

    sorter = conf.generic_sorter(opts),
    attach_mappings = function()
      actions.select_default:replace(function(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd("call feedkeys(':e " .. selection.value .. "/')")
      end)
      return true
    end,
  }):find()
end -- end custom function

return telescope.register_extension({ exports = { open_dir = open_dir } })
