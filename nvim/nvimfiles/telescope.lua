local actions = require('telescope.actions')
local transform_mod = require('telescope.actions.mt').transform_mod

local mods = transform_mod({
  accept_selection = function()
    -- this doesn't work straight up, see https://github.com/nanotee/nvim-lua-guide#vimapinvim_replace_termcodes
    -- vim.fn.feedkeys("<esc>")
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<esc><cr>', true, true, true))
  end,
})

require('telescope').setup{
  defaults = {
    --[[
    --
    -- TODO: check if vimgrep's rg config is being used here
    -- vimgrep_arguments = {
      --   'rg',
      --   '--color=never',
      --   '--no-heading',
      --   '--with-filename',
      --   '--line-number',
      --   '--column',
      --   '--smart-case',
      --   '--hidden',
      --   -- "-g '!**/.git/**'"
      --   a better arg git exclude set is here https://dev.to/hayden/optimizing-your-workflow-with-fzf-ripgrep-2eai
      -- },
      --]]

      prompt_position = "top",
      sorting_strategy = "ascending",
      prompt_prefix = " ⚡ ",
      file_ignore_patterns = { "node_modules", "__pycache__", ".DS_Store", "package-lock.json", ".git" },
      selection_caret = "› ",
      file_sorter = require('telescope.sorters').get_fzy_sorter,
      file_previewer = require('telescope.previewers').vim_buffer_cat.new,
      -- this can work too but I cannot see any benefit-> file_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
      grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,

      mappings = {
        i = {
          ["<c-f>"] = mods.accept_selection,
        },
      },
    },
  }

  require('telescope').load_extension('fzy_native')

  -- doesn't shows preview in find_files, i think we can swap previewer
  -- require('telescope').load_extension('media_files')

  -- not installing frecency- doesn't include open buffers for some odd reason
  -- require"telescope".load_extension('frecency')

  local M = {}
  M.search_dotfiles = function()
    require("telescope.builtin").find_files({
      prompt_title = "vimrc",
      cwd = "~/.config/nvim"
    })
  end

  return M

