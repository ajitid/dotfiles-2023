local keymap = require("which-key").register

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

function basic_keymaps()
  keymap({
    d = { vim.lsp.buf.definition, "definition", buffer=0 },
    D = { vim.lsp.buf.type_definition, "type definition", buffer=0 },
    i = { vim.lsp.buf.implementation, "implementation", buffer=0 },
    r = { vim.lsp.buf.references, "references", buffer=0 },
  }, {
    prefix = "g"
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
      c = { vim.lsp.buf.incoming_calls, "callers for symbol", buffer=0 },
      a = { "<cmd>Telescope lsp_code_actions<cr>", "code actions", buffer=0 },
    },
    f = {
      name = "file",
      s = { "<cmd>Telescope lsp_document_symbols<cr>", "symbols", buffer=0 },
    },
    w = {
      name = "workspace",
      s = { ":Telescope lsp_workspace_symbols query=", "symbols", buffer=0 },
    },
  }, {
      prefix = "<leader>"
  })

  keymap({
    c = {
      a = { "<cmd>Telescope lsp_range_code_actions<cr>", "code actions", buffer=0 },
    },
  }, {
    mode = "v",
    prefix = "<leader>"
  })

  vim.keymap.set("n", "]d", function()
    vim.diagnostic.goto_next()
    vim.call('repeat#set', ']d')
  end, {buffer=0})
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.goto_prev()
    vim.call('repeat#set', '[d')
  end, {buffer=0})
  vim.keymap.set("n", "]D", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
    vim.call('repeat#set', ']D')
  end, {buffer=0})
  vim.keymap.set("n", "[D", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
    vim.call('repeat#set', '[D')
  end, {buffer=0})

  vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, {buffer=0})
end

function format_on_save(client)
  if client.resolved_capabilities.document_formatting then
    vim.keymap.set("n", "<leader>f=", vim.lsp.buf.formatting_sync, {buffer=0})

    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    -- vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
    -- this one doesn't asks which server to use to format:
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end

  if client.resolved_capabilities.document_range_formatting then
    vim.keymap.set("v", "<leader>=", vim.lsp.buf.range_formatting, {buffer=0})
  end
end

function signature_help(client)
  if client.server_capabilities.signatureHelpProvider then
    require"mine.lsp.signature-help".signature_setup(client)
  end
end

require'lspconfig'.gopls.setup{
  capabilities = capabilities,
  on_attach = function(client)
    basic_keymaps()
    format_on_save(client)
    signature_help(client)
  end,
}

local lsp_installer = require("nvim-lsp-installer")

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
  local new_name = vim.fn.input("Rename file to: ", old_name, "file")
  local root_dir = vim.fn.getcwd()
  function on_ok()
      vim.api.nvim_command('Move ' .. new_name)
  end
  typescript_rename_file(root_dir .. "/" .. old_name, root_dir .. "/" .. new_name, on_ok)
end

lsp_installer.on_server_ready(function(server)
    local opts = {
      capabilities = capabilities,
      on_attach = function(client)
        basic_keymaps()

        signature_help(client)

        if server.name == "tsserver" then
          vim.keymap.set("n", "<leader>fr", typescript_rename_file_command, {buffer=0})

          -- needed, otherwise on save nvim would ask whether to save using null-ls (prettier) or tsserver
          client.resolved_capabilities.document_formatting = false
          -- this, if I remember correctly is to improve perf. I'm keeping it commented for now:
          -- client.config.flags.allow_incremental_sync = true
        elseif server.name == "jsonls" then
          client.resolved_capabilities.document_formatting = false
        else
          format_on_save(client)
        end
      end,
    }

    if server.name == "jsonls" then
      opts.settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
        },
      }
    end

    server:setup(opts)
end)

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
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping(function(fallback)
      if not cmp.confirm({ select = true }) then
        require("pairs.enter").type()
      end
    end),
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
  experimental = {
    -- native_menu = false,
    ghost_text = true,
  },
  formatting = {
    format = function(_, vim_item)
      vim_item.kind = (cmp_kinds[vim_item.kind] or '') .. vim_item.kind
      return vim_item
    end,
  },
})

local kind = cmp.lsp.CompletionItemKind

cmp.event:on("confirm_done", function(event)
  local item = event.entry:get_completion_item()
  local parensDisabled = item.data and item.data.funcParensDisabled or false
  if not parensDisabled and (item.kind == kind.Method or item.kind == kind.Function) then
    require("pairs.bracket").type_left("(")
  end
end)

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
  null_ls.builtins.formatting.goimports,
}

local config = {
  on_attach = function(client, bufnr)
    format_on_save(client)
  end,
  sources = sources,
}

null_ls.setup(config)

