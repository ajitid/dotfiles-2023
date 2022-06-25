local keymap = require("which-key").register

require("nvim-lsp-installer").setup({
  ensure_installed = { 'eslint', 'jsonls', 'pyright', 'tsserver', 'cssls', 'marksman' }
})
require('aerial').setup({})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require'lspconfig'

require "lsp_signature".setup({
  bind=true,
  handler_opts = {
    border = "none",
  },
  padding = ' ',
  hint_enable = false,
  doc_lines = 0,
})

local fzf = require"fzf-lua"

function basic_keymaps()
  keymap({
    d = { vim.lsp.buf.definition, "definition", buffer=0 },
    D = { vim.lsp.buf.type_definition, "type definition", buffer=0 },
    r = { vim.lsp.buf.references, "references", buffer=0 },
  }, {
    prefix = "g"
  })

  keymap({
    name = "goto",
    d = { vim.lsp.buf.definition, "definition", buffer=0 },
    D = { vim.lsp.buf.type_definition, "type definition", buffer=0 },
    i = { vim.lsp.buf.implementation, "implementation", buffer=0 },
    r = { vim.lsp.buf.references, "references", buffer=0 },
    c = { vim.lsp.buf.incoming_calls, "callers for symbol", buffer=0 },
  }, {
    prefix = "<leader>g"
  })

  vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
  keymap({
    -- vim.keymap.set("n", "<leader>K", function()
    --   vim.api.nvim_command [[exe "norm KK"]]
    --   vim.api.nvim_command [[sleep 60m]]
    --   vim.api.nvim_command [[exe "norm \<c-w>J"]]
    -- end, {buffer=0})
    -- ^ same solution below, but longer (and w/ different a syntax highlight way)
    K = { require"mine.lsp.hover".hover, "doc in a buffer", buffer=0 },
    c = {
      name = "code",
      r = { vim.lsp.buf.rename, "rename symbol", buffer=0 },
      a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "code actions", buffer=0 },
      s = { vim.lsp.buf.signature_help, "fn signature", buffer=0 },
    },
    f = {
      name = "file",
      s = { fzf.lsp_document_symbols, "symbols", buffer=0 },
      S = { "<cmd>AerialToggle<cr>", "symbols in sidebar", buffer=0 },
    },
    w = {
      name = "workspace",
      s = { ":Telescope lsp_workspace_symbols query=", "symbols", buffer=0, silent=false },
    },
  }, {
      prefix = "<leader>"
  })

  keymap({
    c = {
      a = { ":lua vim.lsp.buf.range_code_action()<cr>", "code actions", buffer=0 },
    },
  }, {
    mode = "v",
    prefix = "<leader>"
  })
end

function diagnostic_keymaps()
  keymap({
    ["<leader>d"] = { "<cmd>lua vim.diagnostic.open_float()<cr>", "diagnostic at cursor" },
    ["]d"] = { "next diagnostic" },
    ["[d"] = { "prev diagnostic" },
    ["]D"] = { "next error" },
    ["[D"] = { "prev error" },
  })

  vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next({
      float = { scope = 'line' },
      -- see https://vi.stackexchange.com/questions/21086/get-the-length-number-of-colums-in-the-current-line-row#comment36973_21087
      -- and https://stackoverflow.com/a/65615609/7683365
      -- like (0) acts for curr buf, in vimscript `'.'` acts for current line
      cursor_position = {vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_eval('col("$")')}
    })
  end, {buffer=0})
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev({
      float = { scope = 'line' },
      cursor_position = {vim.api.nvim_win_get_cursor(0)[1], 0}
    })
  end, {buffer=0})
  vim.keymap.set("n", "]D", function()
    vim.diagnostic.goto_next({
      float = { scope = 'line' },
      severity = vim.diagnostic.severity.ERROR,
      cursor_position = {vim.api.nvim_win_get_cursor(0)[1], vim.api.nvim_eval('col("$")')}
    })
  end, {buffer=0})
  vim.keymap.set("n", "[D", function()
    vim.diagnostic.goto_prev({
      float = { scope = 'line' },
      severity = vim.diagnostic.severity.ERROR,
      cursor_position = {vim.api.nvim_win_get_cursor(0)[1], 0}
    })
  end, {buffer=0})
end

function format_keymaps(client)
  if client.server_capabilities.documentFormattingProvider then
    keymap({
      ["<leader>f="] = {
        function()
          vim.lsp.buf.format({ timeout_ms = 2500 })
        end,
        "format file",
        buffer=0
      }
    })

    vim.cmd([[
      augroup lsp_document_format
        autocmd! * <buffer>
        autocmd BufWritePre <buffer> lua vim.lsp.buf.format({ timeout_ms = 2500 })
      augroup END
    ]])
  end

  if client.server_capabilities.documentRangeFormattingProvider then
    keymap({
      ["<leader>="] = {
        ":lua vim.lsp.buf.range_formatting()<cr>",
        "block formatting",
        buffer=0,
        mode="v"
      }
    })
  end
end

function disable_formatting(client)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false
end

function common_on_attach(client, bufnr)
  -- not sure how much useful this setting is
  vim.api.nvim_buf_set_option(bufnr, 'formatexpr', 'v:lua.vim.lsp.formatexpr')

  basic_keymaps()
  diagnostic_keymaps()
  format_keymaps(client)
  require("aerial").on_attach(client, bufnr)
end

-- install manually
lspconfig.gopls.setup{
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    disable_formatting(client)
    common_on_attach(client, bufnr)
  end,
}

-- from https://github.com/williamboman/nvim-lsp-installer/blob/b14bd0c5d75ca9da91d7675e98b89450b08f0143/lua/nvim-lsp-installer/extras/tsserver.lua
-- also see https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils/blob/627963630691c3f3113a8b549fca4246ed4960eb/lua/nvim-lsp-ts-utils/rename-file.lua#L14-L22
function send_client_request(client_name, ...)
    for _, client in pairs(vim.lsp.get_active_clients()) do
        if client.name == client_name then
            return client.request(...)
        end
    end
end

echo_warning = function(message)
    api.nvim_echo({ { "LSP: " .. message, "WarningMsg" } }, true, {})
end

function noop()
end

function typescript_rename_file(old_name, new_name, on_ok)
    on_ok = on_ok or noop

    local old_uri = vim.uri_from_fname(old_name)
    local new_uri = vim.uri_from_fname(new_name)

    local ok = send_client_request("tsserver", "workspace/executeCommand", {
        command = "_typescript.applyRenameFile",
        arguments = {
            {
                sourceUri = old_uri,
                targetUri = new_uri,
            },
        },
    })

    if not ok then
      echo_warning("failed to rename " .. old_name)
    else
      on_ok()
    end
end

function typescript_rename_file_command()
  local old_name = vim.fn.expand('%:p:.')
  local new_name = nil
  -- err occurs when one presses ctrl+c (Keyboard interrupt)
  local status, err = pcall(function() new_name = vim.fn.input("Rename file to: ", old_name, "file") end)
  -- new_name is '' when esc key is pressed
  if err ~= nil or new_name == '' then
    return
  end

  local root_dir = vim.fn.getcwd()
  function on_ok()
      vim.api.nvim_command('Move ' .. new_name)
  end
  typescript_rename_file(root_dir .. "/" .. old_name, root_dir .. "/" .. new_name, on_ok)
end

lspconfig.tsserver.setup{
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- needed, otherwise on save nvim would ask whether to save using null-ls (prettier) or tsserver
    disable_formatting(client)
    -- this, if I remember correctly is to improve perf. I'm keeping it commented for now:
    -- client.config.flags.allow_incremental_sync = true

    common_on_attach(client, bufnr)
    keymap({ ["<leader>fr"] = { typescript_rename_file_command, "rename using LSP", buffer=0 } })
  end,
}

lspconfig.jsonls.setup{
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    disable_formatting(client)
    common_on_attach(client, bufnr)
  end,
  settings = {
    json = {
      schemas = require('schemastore').json.schemas(),
    },
  },
}

lspconfig.pyright.setup{
  capabilities = capabilities,
  on_attach = common_on_attach,
}

lspconfig.eslint.setup{
  capabilities = capabilities,
  on_attach = common_on_attach,
}

lspconfig.cssls.setup{
  capabilities = capabilities,
  on_attach = common_on_attach,
}

lspconfig.marksman.setup{
  capabilities = capabilities,
  on_attach = common_on_attach,
}

local cmp = require'cmp'

-- needs codicon fonts to render, grab it from https://github.com/microsoft/vscode-codicons/blob/main/dist/codicon.ttf
local cmp_kinds = {
  Text = '  ',
  Method = '  ',
  Function = '  ',
  Constructor = '  ',
  Field = '  ',
  Variable = '  ',
  Class = '  ',
  Interface = '  ',
  Module = '  ',
  Property = '  ',
  Unit = '  ',
  Value = '  ',
  Enum = '  ',
  Keyword = '  ',
  Snippet = '  ',
  Color = '  ',
  File = '  ',
  Reference = '  ',
  Folder = '  ',
  EnumMember = '  ',
  Constant = '  ',
  Struct = '  ',
  Event = '  ',
  Operator = '  ',
  TypeParameter = '  ',
}

cmp.setup({
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
    }),
    ["<tab>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 4 },
  }, {
    { name = 'buffer' },
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  view = {
    entries = 'native'
  },
  experimental = {
    ghost_text = {
      hl_group = 'CmpGhostText'
    },
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. vim_item.kind
      return vim_item
    end,
  },
})

-- null-ls stuff is mostly taken from https://github.com/Gelio/ubuntu-dotfiles/blob/master/install/neovim/stowed/.config/nvim/lua/lsp/null-ls.lua
-- other links to refer:
-- https://old.reddit.com/r/neovim/comments/qckrnp/share_your_prettier_and_eslint_formatting_setup/
-- https://old.reddit.com/r/neovim/comments/rn0dnp/formatting_markdown_with_nullls_and_prettierd_not/
-- https://old.reddit.com/r/neovim/comments/rjvmht/lua_vimlspbufformatting_sync_doesnt_always_run/hpa0u21/
-- old but still https://old.reddit.com/r/neovim/comments/oxl9pz/whats_the_recommended_way_to_handle_formatting/

local null_ls = require("null-ls")

local prettierd_filetypes = { unpack(null_ls.builtins.formatting.prettierd.filetypes) }
table.insert(prettierd_filetypes, "jsonc")

local sources = {
  -- if prettierd is not present, the command will silently fail
  null_ls.builtins.formatting.prettierd.with({
    filetypes = prettierd_filetypes,
  }),
  -- needs
  -- go install golang.org/x/tools/cmd/goimports@latest
  null_ls.builtins.formatting.goimports,
  null_ls.builtins.formatting.gofmt,
  null_ls.builtins.diagnostics.vale,
}

local config = {
  on_attach = function(client, bufnr)
    -- don't use `disable_formatting`, it is discouraged, see https://github.com/jose-elias-alvarez/null-ls.nvim/issues/778#issuecomment-1103053724
    format_keymaps(client)
    diagnostic_keymaps()
  end,
  sources = sources,
}

null_ls.setup(config)

