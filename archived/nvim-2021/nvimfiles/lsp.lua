local lspconfig = require"lspconfig"
local configs = require'lspconfig/configs'

-- icons for symbols
-- require('lspkind').init({})

-- hide diagnostics from apppearing automatically beside each line 
-- https://www.reddit.com/r/neovim/comments/kx8de9/hiding_virtual_text_for_stopped_working/
-- https://sourcegraph.com/github.com/neovim/neovim/-/blob/runtime/lua/vim/lsp/diagnostic.lua#L967
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
  -- TODO virtual text is useful on a widescreen monitor
  -- virtual_text = false
  virtual_text = {
    spacing = 2,
    prefix = '«'
  }
}
)

-- LSP completions using compe
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.html.setup {
  capabilities = capabilities,
}

lspconfig.cssls.setup{
  capabilities = capabilities,
}

lspconfig.pyright.setup{}

-- i prefer non LSP one which provides proper jumps, i miss preview but that's not a big issue
-- that being said, i'm keeping LSP version for now
-- configs.emmet_ls = {
--   default_config = {
--     cmd = {'emmet-ls', '--stdio'};
--     filetypes = {'html', 'css'};
--     root_dir = function()
--       return vim.loop.cwd()
--     end;
--     settings = {};
--   };
-- }
--[[
-- https://github.com/aca/emmet-ls 
-- this causes issue when VimRC is sourced
-- lspconfig.emmet_ls.setup{ on_attach = function() end }
--]]


-- eslint, typescript
local installed_servers = require'nvim-lsp-installer'.get_installed_servers()
for _, server in pairs(installed_servers) do
  opts = {
    on_attach = function(client, bufnr)

      if server.name == "tsserver" then
        if not client.config.flags then
          client.config.flags = {}
        end
        client.config.flags.allow_incremental_sync = true

        client.resolved_capabilities.document_formatting = false

        -- works but still track ticket here https://github.com/glepnir/lspsaga.nvim/issues/145#issuecomment-828227786
        -- TODO highlight instead of backticking current fn arg
        require "lsp_signature".on_attach({
          bind = true,
          handler_opts = {
            border = "none"
          },
          -- hi_parameter = "markdownCode",
          hint_enable = false,
          hint_prefix = "👇 ",
        })
        --   require('folding').on_attach()

        local ts_utils = require("nvim-lsp-ts-utils")

        ts_utils.setup {
           -- eslint
            eslint_enable_code_actions = false,
            eslint_enable_disable_comments = false,
        }

        ts_utils.setup_client(client)
      end
    end,
  }

  if server.name == "eslintls" then
    opts.settings = {
      codeAction = {
        disableRuleComment = {
          location = "separateLine"
        },
        showDocumentation = {
          enable = false
        }
      }
    }
  end
  -- TODO: check for eslint cfg using that other method, 
  -- maybe, eslint raises error if cannot find config, i might need use that to not run eslint at all
  -- TODO: combine code action from all sources, use a TS CRA with incomplete dep list of useEffect to get code actions from
  -- more than one source
  server:setup(opts)
end

local rust_options = {
  tools = {
    autoSetHints = true,
    hover_with_actions = true,
    runnables = {
      use_telescope = true
    },
    inlay_hints = {
      show_parameter_hints = true,
    },
  },
  server = {}
}

require('rust-tools').setup(rust_options)

-- from https://old.reddit.com/r/neovim/comments/n1n4zc/need_help_with_tsconfigjson_autocompletion_with/gwegsb0/
-- https://github.com/ahmedelgabri/dotfiles/blob/c2e2e3718e769020f1468048e33e60ad8a97edfc/config/.vim/lua/_/lsp.lua#L329-L378
lspconfig.jsonls.setup{
  capabilities = capabilities,
  filetypes = {"json", "jsonc"},
  settings = {
    json = {
      -- Schemas https://www.schemastore.org
      schemas = {
        {
          fileMatch = {"package.json"},
          url = "https://json.schemastore.org/package.json"
        },
        {
          fileMatch = {"tsconfig*.json"},
          url = "https://json.schemastore.org/tsconfig.json"
        },
        {
          fileMatch = {
            ".prettierrc",
            ".prettierrc.json",
            "prettier.config.json"
          },
          url = "https://json.schemastore.org/prettierrc.json"
        },
        {
          fileMatch = {".eslintrc", ".eslintrc.json"},
          url = "https://json.schemastore.org/eslintrc.json"
        },
        {
          fileMatch = {".babelrc", ".babelrc.json", "babel.config.json"},
          url = "https://json.schemastore.org/babelrc.json"
        },
        {
          fileMatch = {"lerna.json"},
          url = "https://json.schemastore.org/lerna.json"
        },
        {
          fileMatch = {"now.json", "vercel.json"},
          url = "https://json.schemastore.org/now.json"
        },
        {
          fileMatch = {
            ".stylelintrc",
            ".stylelintrc.json",
            "stylelint.config.json"
          },
          url = "http://json.schemastore.org/stylelintrc.json"
        }
      }
    }
  }
}