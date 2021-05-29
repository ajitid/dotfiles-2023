local vim = vim
local telescope = require("telescope")
local builtIn = require("telescope.builtin")
local actions = require('telescope.actions')
local action_state = require("telescope.actions.state")
local transform_mod = require('telescope.actions.mt').transform_mod

local mods = transform_mod({
  accept_selection = function()
    -- this doesn't work straight up, see https://github.com/nanotee/nvim-lua-guide#vimapinvim_replace_termcodes
    -- vim.fn.feedkeys("<esc>")
    -- ^ maybe this needed backslash like so `"\<esc>"`
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<esc><cr>', true, true, true))
  end,
  send_to_command_prompt = function(prompt_bufnr)
    local selection = action_state.get_selected_entry()
    actions.close(prompt_bufnr)
    -- https://github.com/nvim-telescope/telescope.nvim/blob/1fefd0098e92315569b71a99725b63521594991e/lua/telescope/actions/init.lua#L226
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(": " .. selection.value .. "<home>" , true, false, true), "t", true)
  end,
})

telescope.setup{
  defaults = {
    prompt_position = "top",
    sorting_strategy = "ascending",
    prompt_prefix = " ⚡ ",

    file_ignore_patterns = {
      ".git/",
      ".DS_Store", ".vscode/",
      "node_modules/", "__pycache__/",
      "package%-lock.json", "yarn.lock", "pnpm%-lock.yaml",
      "build/", "dist/",
    },
    -- ^ telescope uses lua's pattern matching library, see:
    -- https://github.com/nvim-telescope/telescope.nvim/issues/780
    -- https://gitspartv.github.io/lua-patterns/

    selection_caret = "› ",
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    -- this can work too but I cannot see any benefit-> file_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,

    mappings = {
      i = {
        ["<esc>"] = actions.close,
        -- TODO multiple file selection on <cr> if used <tab> https://github.com/nvim-telescope/telescope.nvim/issues/814
        ["<CR>"] = actions.select_default,
        ["<Tab>"] = actions.toggle_selection,
        -- from https://github.com/nvim-telescope/telescope.nvim/issues/42#issuecomment-822037307
        ["<c-q>"] = actions.smart_send_to_qflist
      }
    },
  },

  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = false,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  },
}

telescope.load_extension('fzf')
telescope.load_extension('ultisnips')
telescope.load_extension('open_dir')

local function generateOpts(opts)
  local common_opts = {
    layout_strategy = "center",
    sorting_strategy = "ascending",
    results_title = false,
    preview_title = "Preview",
    previewer = false,
    width = 80,
    results_height = 15,
    borderchars = {
      {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
      prompt = {"─", "│", " ", "│", "╭", "╮", "│", "│"},
      results = {"─", "│", "─", "│", "├", "┤", "╯", "╰"},
      preview = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"}
    }
  }

  return vim.tbl_extend("force", opts, common_opts)
end

local M = {}

M.search_dotfiles = function()
  builtIn.find_files({
    prompt_title = "vimrc",
    cwd = "~/.config/nvim"
  })
end

function M.colors()
  local opts = generateOpts({})
  builtIn.colorscheme(opts)
end

function M.find_files()
  local opts = generateOpts({})
  opts.hidden = true
  opts.attach_mappings = function(_, map)
    map('i', '<c-x>', mods.send_to_command_prompt)
    return true
  end
  builtIn.find_files(opts)
end

return M

