local lspconfig = require"lspconfig"
local configs = require'lspconfig/configs'

-- icons for symbols
require('lspkind').init({})

-- hide diagnostics from apppearing automatically beside each line 
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
vim.lsp.diagnostic.on_publish_diagnostics, {
  virtual_text = false
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

-- i prefer non LSP one which provides proper jumps, i miss preview but that's not a big issue
-- that being said, i'm keeping LSP version for now
configs.emmet_ls = {
  default_config = {
    cmd = {'emmet-ls', '--stdio'};
    filetypes = {'html', 'css'};
    root_dir = function()
      return vim.loop.cwd()
    end;
    settings = {};
  };
}

--[[
-- https://github.com/aca/emmet-ls 
-- this causes issue when VimRC is sourced
-- lspconfig.emmet_ls.setup{
  --   on_attach = function() end
  -- }
  --]]

  --[[
  -- TS support is now handled by nvim-lsp-installer
  -- lspconfig.tsserver.setup({
    --   -- incremental sync is enabled by default https://github.com/neovim/neovim/issues/13049#issuecomment-808686843
    --   on_attach = function(client)
      --     -- Folding using LSP using folding-nvim
      --     -- require('folding').on_attach()
      --   end, 
      --   capabilities = capabilities
      -- })
      --]]

      -- eslint, typescript
      local installed_servers = require'nvim-lsp-installer'.get_installed_servers()
      for _, server in pairs(installed_servers) do
        opts = {
          on_attach = function()
            -- if server.name == "tsserver" then
            --   require('folding').on_attach()
            -- end
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

