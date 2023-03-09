local ts = require'nvim-treesitter.configs'

ts.setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
    disable = { "markdown", "markdown_inline" }
  },
  indent = {
    -- FIXME commented as it breaks indent https://github.com/nvim-treesitter/nvim-treesitter/issues/2544
    -- and https://github.com/nvim-treesitter/nvim-treesitter/issues/2369
    enable = false,
  },
  matchup = {
    enable = true,
  },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
      },
    },
    move = {
      enable = true,
      goto_next_start = {
        ["]]"] = "@function.outer",
      },
      goto_previous_start = {
        ["[["] = "@function.outer",
      },
      goto_next_end = {
        ["]["] = "@function.outer",
      },
      goto_previous_end = {
        ["[]"] = "@function.outer",
      },
    },
  },
}

require('Comment').setup({
  pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
})
