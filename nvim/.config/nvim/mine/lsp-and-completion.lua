local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

function basic_keymaps()
  vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
  vim.keymap.set("n", "<leader>K", function()
    vim.api.nvim_command [[exe "norm KK"]]
    vim.api.nvim_command [[sleep 60m]]
    vim.api.nvim_command [[exe "norm \<c-w>J"]]
  end, {buffer=0})
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
  vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, {buffer=0})
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
  vim.keymap.set("n", "gr", vim.lsp.buf.references, {buffer=0})
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {buffer=0})
  vim.keymap.set("n", "<leader>cc", vim.lsp.buf.incoming_calls, {buffer=0})
  vim.keymap.set("n", "<leader>ca",  "<cmd>Telescope lsp_code_actions<cr>", {buffer=0})
  vim.keymap.set("v", "<leader>ca",  "<cmd>Telescope lsp_range_code_actions<cr>", {buffer=0})
  vim.keymap.set("n", "<leader>fs",  "<cmd>Telescope lsp_document_symbols<cr>", {buffer=0})
  vim.keymap.set("n", "<leader>ws",  ":Telescope lsp_workspace_symbols query=", {buffer=0})

  vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, {buffer=0})
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {buffer=0})
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {buffer=0})
  vim.keymap.set("n", "]D", function()
    vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
  end, {buffer=0})
  vim.keymap.set("n", "[D", function()
    vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
  end, {buffer=0})

  vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, {buffer=0})
end


-- lsp signature on method
-- taken from https://www.reddit.com/r/neovim/comments/so4g5e/comment/hw7ft3i/?utm_source=share&utm_medium=web2x&context=3
local M = {}

-- Thanks to @akinsho for this brilliant function white waiting for builtin autocmd in lua
-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/lua/as/globals.lua
M.augroup = function(name, commands, buffer)
    _G.__seblj_global_callbacks = __seblj_global_callbacks or {}

    _G.seblj = {
        _store = __seblj_global_callbacks,
    }

    vim.cmd('augroup ' .. name)
    if buffer then
        vim.cmd('au! * <buffer>')
    else
        vim.cmd('au!')
    end
    if #commands > 0 then
        for _, c in ipairs(commands) do
            M.autocmd(c)
        end
    else
        M.autocmd(commands)
    end
    vim.cmd('augroup END')
end

M.autocmd = function(c)
    _G.__seblj_global_callbacks = __seblj_global_callbacks or {}

    _G.seblj = {
        _store = __seblj_global_callbacks,
    }

    local command = c.command
    if type(command) == 'function' then
        table.insert(seblj._store, command)
        local fn_id = #seblj._store
        command = string.format('lua seblj._store[%s](args)', fn_id)
    end
    local event = c.event
    if type(c.event) == 'table' then
        event = table.concat(c.event, ',')
    end

    local pattern = c.pattern or ''
    if type(c.pattern) == 'table' then
        pattern = table.concat(c.pattern, ',')
    end

    local once = ''
    if c.once == true then
        once = '++once '
    end
    local nested = ''
    if c.nested == true then
        nested = '++nested '
    end

    vim.cmd(string.format('autocmd %s %s %s %s %s', event, pattern, once, nested, command))
end

local clients = {}

local check_trigger_char = function(line_to_cursor, triggers)
    if not triggers then
        return false
    end

    for _, trigger_char in ipairs(triggers) do
        local current_char = line_to_cursor:sub(#line_to_cursor, #line_to_cursor)
        local prev_char = line_to_cursor:sub(#line_to_cursor - 1, #line_to_cursor - 1)
        if current_char == trigger_char then
            return true
        end
        if current_char == ' ' and prev_char == trigger_char then
            return true
        end
    end
    return false
end

local open_signature = function()
    local triggered = false

    for _, client in pairs(clients) do
        local triggers = client.server_capabilities.signatureHelpProvider.triggerCharacters

        -- csharp has wrong trigger chars for some odd reason
        if client.name == 'csharp' then
            triggers = { '(', ',' }
        end

        local pos = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_get_current_line()
        local line_to_cursor = line:sub(1, pos[2])

        if not triggered then
            triggered = check_trigger_char(line_to_cursor, triggers)
        end
    end

    if triggered then
        vim.lsp.buf.signature_help()
    end
end

local signature_setup = function(client)
    table.insert(clients, client)
    M.augroup('Signature', {
        event = 'TextChangedI',
        pattern = '<buffer>',
        command = function()
            open_signature()
        end,
    }, true)
end

function format_on_save(client)
  if client.resolved_capabilities.document_formatting then
    vim.keymap.set("n", "<leader>f=", vim.lsp.buf.formatting_sync, {buffer=0})

    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
    vim.api.nvim_command [[augroup END]]
  end

  if client.resolved_capabilities.document_range_formatting then
    vim.keymap.set("v", "<leader>=", vim.lsp.buf.range_formatting, {buffer=0})
  end
end

require'lspconfig'.gopls.setup{
  capabilities = capabilities,
  on_attach = function(client)
    basic_keymaps()
    format_on_save(client)

    if client.server_capabilities.signatureHelpProvider then
      require('config.lspconfig.signature').setup(client)
    end
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

        if client.server_capabilities.signatureHelpProvider then
          signature_setup(client)
        end

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
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
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
    native_menu = false,
    ghost_text = true,
  },
  formatting = {
    format = require'lspkind'.cmp_format({
      mode = 'text',
      maxwidth = 50,
    })
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
}

local config = {
  on_attach = function(client, bufnr)
    format_on_save(client)
  end,
  sources = sources,
}

null_ls.setup(config)

