local has_telescope, telescope = pcall(require, "telescope")
if not has_telescope then
  error("This plugins requires nvim-telescope/telescope.nvim")
end

local conf = require("telescope.config").values
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local action_state = require("telescope.actions.state")
local Path = require "plenary.path"
local previewers = require "telescope.previewers"
local action_set = require "telescope.actions.set"
local utils = require "telescope.utils"
local entry_display = require "telescope.pickers.entry_display"
local strings = require "plenary.strings"

function gen_from_ctags(opts)
  opts = opts or {}

  local cwd = vim.fn.expand(opts.cwd or vim.loop.cwd())
  local current_file = Path:new(vim.api.nvim_buf_get_name(opts.bufnr)):normalize(cwd)

  local display_items = {
    { remaining = true },
  }
  local hidden = utils.is_path_hidden(opts)
  if not hidden then
    table.insert(display_items, 1, { width = 30 })
  end

  if opts.show_line then
    table.insert(display_items, 1, { width = 30 })
  end

  local displayer = entry_display.create {
    separator = " │ ",
    items = display_items,
  }

  local make_display = function(entry)
    local filename = utils.transform_path(opts, entry.filename)

    local scode
    if opts.show_line then
      scode = entry.scode
    end

    if hidden then
      return displayer {
        entry.tag,
        scode,
      }
    else
      return displayer {
        entry.tag,
        filename,
        scode,
      }
    end
  end

  local mt = {}
  mt.__index = function(t, k)
    if k == "path" then
      local retpath = Path:new({ t.filename }):absolute()
      if not vim.loop.fs_access(retpath, "R", nil) then
        retpath = t.filename
      end
      return retpath
    end
  end

  return function(line)
    if line == "" or line:sub(1, 1) == "!" then
      return nil
    end

    local tag, file, scode, lnum
    -- ctags gives us: 'tags\tfile\tsource'
    tag, file, scode = string.match(line, '([^\t]+)\t([^\t]+)\t/^?\t?(.*)/;"\t+.*')
    if not tag then
      -- hasktags gives us: 'tags\tfile\tlnum'
      tag, file, lnum = string.match(line, "([^\t]+)\t([^\t]+)\t(%d+).*")
    end

    if Path.path.sep == "\\" then
      file = string.gsub(file, "/", "\\")
    end

    if opts.only_current_file and file ~= current_file then
      return nil
    end

    local tag_entry = {}
    if opts.only_sort_tags then
      tag_entry.ordinal = tag
    else
      tag_entry.ordinal = file .. ": " .. tag
    end

    tag_entry.display = make_display
    tag_entry.scode = scode
    tag_entry.tag = tag
    tag_entry.filename = file
    tag_entry.col = 1
    tag_entry.lnum = lnum and tonumber(lnum) or 1

    return setmetatable(tag_entry, mt)
  end
end

local gtags = function(opts)
  opts = opts or {}
  opts.bufnr = opts.bufnr or 0
  opts.only_sort_tags = true

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
      entry_maker = opts.entry_maker or gen_from_ctags(opts),
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
