local fzf_defaults = require('fzf-lua.defaults').defaults
local fzf = require"fzf-lua"
local keymap = require("which-key").register

local function default_action(selected)
  vim.cmd("call feedkeys(':e " .. selected[1] .. "')")
end

local function find_folder()
  fzf.files({
    -- LHS of concatenation is fzf_defaults.files.fd_opts but with `--type d`
    fd_opts = "--color=never --type d --hidden --follow --exclude .git" .. " --strip-cwd-prefix",
    previewer = false,
    actions = {
      ["default"] = default_action,
    },
  })
end

keymap({
  ["."] = { function() fzf.files({ cwd = vim.fn.expand('%:h'), fd_opts = fzf_defaults.files.fd_opts .. " --max-depth 1" }) end, 'find file in buffer dir' },
  ["-"] = { find_folder, "find dir" },
}, {
    prefix = "<leader>"
})

