local vim = vim
local telescope = require("telescope")
local builtIn = require("telescope.builtin")
local actions = require('telescope.actions')
local transform_mod = require('telescope.actions.mt').transform_mod

local mods = transform_mod({
  accept_selection = function()
    -- this doesn't work straight up, see https://github.com/nanotee/nvim-lua-guide#vimapinvim_replace_termcodes
    -- vim.fn.feedkeys("<esc>")
    -- ^ maybe this needed backslash like so `"\<esc>"`
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<esc><cr>', true, true, true))
  end,
})

telescope.setup{
  defaults = {
    prompt_position = "top",
    sorting_strategy = "ascending",
    prompt_prefix = " ⚡ ",
    file_ignore_patterns = { ".git/", "node_modules/", "__pycache__/", ".DS_Store", "package-lock.json", "yarn.lock" },
    selection_caret = "› ",
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    -- this can work too but I cannot see any benefit-> file_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,

    mappings = {
      i = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<Tab>"] = actions.toggle_selection
      }
    },

    extensions = {
      fzf = {
        override_generic_sorter = false, -- override the generic sorter
        override_file_sorter = true,     -- override the file sorter
      }
    },

  },
}

telescope.load_extension('fzf')
telescope.load_extension('ultisnips')

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
  builtIn.find_files(opts)
end

return M

