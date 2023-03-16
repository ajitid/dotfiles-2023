local keymap = require("which-key").register

require("mason").setup {}
require("mason-lspconfig").setup({
  ensure_installed = {
    'eslint',
    'jsonls',
    'pyright',
    'tsserver',
    'cssls',
    'marksman',
    'tailwindcss',
    'astro',
    'html'
  }
})
require('aerial').setup({})

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
local lspconfig = require'lspconfig'

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
    ["<c-w>d"] =  { "<cmd>vsplit | norm gd<cr>", "vsplit and go to def.", buffer=0 },
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
    k = { require"mine.lsp.hover".hover, "doc in a buffer", buffer=0 },
    c = {
      name = "code",
      r = { vim.lsp.buf.rename, "rename symbol", buffer=0 },
      a = { vim.lsp.buf.code_action, "code actions", buffer=0 },
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
      -- we have a way to extact range now https://github.com/neovim/neovim/issues/18533#issuecomment-1131471721
      a = { vim.lsp.buf.code_action, "code actions", buffer=0 },
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
end

-- install manually
lspconfig.gopls.setup{
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    disable_formatting(client)
    common_on_attach(client, bufnr)
    require('folding').on_attach()
  end,
  settings = {
    gopls = {
      env = {
        -- from https://github.com/golang/go/issues/29202#issuecomment-1233042513
        GOFLAGS = "-tags=windows,linux,darwin"
      }
    }
  }
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
    vim.api.nvim_echo({ { "LSP: " .. message, "WarningMsg" } }, true, {})
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

function typescript_go_to_source_definiton()
  -- there's also vim.api.nvim_get_current_buf()
  local bufnr = vim.api.nvim_win_get_buf(0);
  local clients = vim.lsp.buf_get_clients(bufnr)
  local client = nil
  for value in values(clients) do
    if value.name == "tsserver" then
      client = value
      break
    end
  end
  if client == nil then
    echo_warning("tsserver not attached, not invoking go to def")
    return
  end

  local offset_encoding = client.positionEncodings or client.offset_encoding
  local position_params = vim.lsp.util.make_position_params(0, offset_encoding)

  client.request(
    "workspace/executeCommand", 
    { command = "_typescript.goToSourceDefinition", arguments = { position_params.textDocument.uri, position_params.position } },
    function(_, result, params)
      if vim.tbl_isempty(result) then
        vim.lsp.buf.definition()
      else
        local util = require("vim.lsp.util")
        util.jump_to_location(result[1], offset_encoding)
      end
    end
  )
end

lspconfig.tsserver.setup{
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    -- needed, otherwise on save nvim would ask whether to save using null-ls (prettier) or tsserver
    disable_formatting(client)
    -- this, if I remember correctly is to improve perf. I'm keeping it commented for now:
    -- client.config.flags.allow_incremental_sync = true

    common_on_attach(client, bufnr)
    require('folding').on_attach()
    keymap({
      ["<leader>fr"] = { typescript_rename_file_command, "rename using LSP", buffer=0 },
      ["gd"] = { typescript_go_to_source_definiton, "go to definiton (DWIM)", buffer=0 },
      ["<leader>gd"] = { typescript_go_to_source_definiton, "go to definiton (DWIM)", buffer=0 }
    })

    local offset_encoding = client.positionEncodings or client.offset_encoding
    -- you can't call multiple of these in sequence, see https://github.com/jose-elias-alvarez/typescript.nvim/issues/33#issuecomment-1258739999
    vim.api.nvim_buf_create_user_command(bufnr, 'TypescriptRemoveUnusedImports',
      function(opts) 
        local params = vim.lsp.util.make_range_params()
        params.context = {
          only = {"source.removeUnused.ts"},
          diagnostics = vim.diagnostic.get(bufnr)
        }

        -- from https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils/blob/0a6a16ef292c9b61eac6dad00d52666c7f84b0e7/lua/nvim-lsp-ts-utils/source-actions.lua#LL32C7-L37C57
        client.request(
          "textDocument/codeAction",
          params,
          function(err, res)
            assert(not err, err)
            if res and res[1] and res[1].edit and res[1].edit.documentChanges and res[1].edit.documentChanges[1] and res[1].edit.documentChanges[1].edits then
              vim.lsp.util.apply_text_edits(res[1].edit.documentChanges[1].edits, bufnr, offset_encoding)
            end
          end
        )
      end,
      {nargs = 0}
    )
  end,
  handlers = {
    -- usually gets called after a code action
    -- like in moving an anonymous function to outer scope
    ["_typescript.rename"] = function(_, result, params)
      local line = result.position.line
      local character = result.position.character

      local client = vim.lsp.get_client_by_id(params.client_id)
      local offset_encoding = client.positionEncodings or client.offset_encoding
      assert(offset_encoding == "utf-16", 
        "`str_byteindex` will fail as it expects encoding to be in utf-16 format. Ajit, you need to accomodate this.")

      -- see commit msg to find resources to learn about these fns
      local column = vim.str_byteindex(vim.fn.getline('.'), character, true)
      vim.api.nvim_win_set_cursor(0, {line+1, column})
      vim.lsp.buf.rename()
      return result
    end,
  }
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

lspconfig.html.setup{
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    disable_formatting(client)
    common_on_attach(client, bufnr)
    require('folding').on_attach()
  end,
}

lspconfig.tailwindcss.setup{
  capabilities = capabilities,
  on_attach = common_on_attach,
}

lspconfig.astro.setup{
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    disable_formatting(client)
    common_on_attach(client, bufnr)
    require('folding').on_attach()
  end,
}

local cmp = require'cmp'
local cmp_buffer = require'cmp_buffer'
local types = require('cmp.types')

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

local function lsp_above(entry1, entry2)
  local kind1 = entry1:get_kind()
  kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
  local kind2 = entry2:get_kind()
  kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2

  if kind1 ~= kind2 then
    local diff = kind1 - kind2
    if diff < 0 then
      return true
    elseif diff > 0 then
      return false
    end
  end
end

cmp.setup({
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i' }),
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
    }),
    ["<tab>"] = cmp.mapping.confirm({ select = true }),
    ["<cr>"] = function(fallback)
      cmp.abort()
      fallback()
    end
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'path' },
    { name = 'luasnip' },
    { name = 'buffer', keyword_length = 4, max_item_count = 4 },
  }, {
    { name = 'buffer' },
  }),
  sorting = {
    -- TODO not needed but interesting, symbol prioritization:
    -- https://github.com/hrsh7th/nvim-cmp/issues/156#issuecomment-916338617
    comparators = {
      require"cmp".config.compare.exact,
      require"cmp".config.compare.score,
      lsp_above,
      function(...) return cmp_buffer:compare_locality(...) end,
      -- keeping the commented code only for reference:
      -- require"cmp".config.compare.kind,
      -- unpack(cmp.get_config().sorting.comparators),
    },
  },
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
    -- TODO see thread https://www.reddit.com/r/neovim/comments/unlj8d/is_there_any_way_to_show_types_in_nvimcmp/i89oqbg/
    -- to show more context in completion
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

local prettierd_filetypes = { table.unpack(null_ls.builtins.formatting.prettierd.filetypes) }
table.insert(prettierd_filetypes, "jsonc")
table.insert(prettierd_filetypes, "astro")

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

