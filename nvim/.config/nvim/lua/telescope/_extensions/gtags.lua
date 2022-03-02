local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugins requires nvim-telescope/telescope.nvim")
end

local conf = require("telescope.config").values
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local action_state = require("telescope.actions.state")
local make_entry = require "telescope.make_entry"
local Path = require "plenary.path"
local previewers = require "telescope.previewers"
local action_set = require "telescope.actions.set"

local gtags = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or 0
  local tagfiles = opts.ctags_file and { opts.ctags_file } or vim.fn.tagfiles()
  if vim.tbl_isempty(tagfiles) then
    print "No tags file found. Create one with ctags -R"
    return
  end

  local results = {}
  for _, ctags_file in ipairs(tagfiles) do
    for line in Path:new(vim.fn.expand(ctags_file, true)):iter() do
      results[#results + 1] = line
    end
  end

  pickers.new(opts, {
    prompt_title = "Tags",
    finder = finders.new_table {
      results = results,
      entry_maker = opts.entry_maker or make_entry.gen_from_ctags(opts),
    },
    previewer = previewers.ctags.new(opts),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function()
      action_set.select:enhance {
        post = function()
          local selection = action_state.get_selected_entry()

          if selection.scode then
            local scode = string.gsub(selection.scode, "[$]$", "")
            scode = string.gsub(scode, [[\\]], [[\]])
            scode = string.gsub(scode, [[\/]], [[/]])
            scode = string.gsub(scode, "[*]", [[\*]])

            vim.cmd "norm! gg"
            vim.fn.search(scode)
            vim.cmd "norm! zz"
          else
            vim.api.nvim_win_set_cursor(0, { selection.lnum, 0 })
          end
        end,
      }
      return true
    end,
  }):find()
end -- end custom function

return telescope.register_extension({ exports = { gtags = gtags } })
