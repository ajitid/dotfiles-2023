local actions = require "fzf-lua.actions"

require'fzf-lua'.setup {
  global_git_icons = false,
  global_file_icons = false,
  border = false,
  fullscreen = true,
  oldfiles = {
    cwd_only = true,
  },
  winopts = {
    preview = {
      layout = 'vertical',
      vertical = 'up:70%',
    },
    hl = {
      search = 'Visual',
      border = 'Normal',
    }
  },
  file_ignore_patterns = {
    ".git/",
    ".DS_Store", ".vscode/", ".idea/",
    "node_modules/", "__pycache__/",
    "package%-lock.json", "yarn.lock", "pnpm%-lock.yaml",
    "build/", "dist/",
    "go.sum", "go/src/",
    "tags",
  },
  fzf_opts = {
    ["--info"] = "default",
  },
  fzf_colors = {
      ["fg"]          = { "fg", "Normal" },
      ["hl"]          = { "fg", "Normal" },
      ["fg+"]         = { "fg", "Normal" },
      ["hl+"]         = { "fg", "Normal" },
      ["bg+"]         = { "bg", "CursorLine" },
      ["pointer"]     = { "fg", "Label" },
      ["marker"]      = { "fg", "Character" },
      ["spinner"]     = { "fg", "Label" },
      ["gutter"]      = { "bg", "Normal" },
  },
}

