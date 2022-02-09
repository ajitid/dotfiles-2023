local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

require'lspconfig'.gopls.setup{
  capabilities = capabilities,
  on_attach = function()
    vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
    vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, {buffer=0})
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
    vim.keymap.set("n", "gr", vim.lsp.buf.references, {buffer=0})
    vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {buffer=0})
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {buffer=0})

    vim.keymap.set("n", "<leader>df", "<cmd>Telescope diagnostics<cr>", {buffer=0})
    vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {buffer=0})
    vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {buffer=0})
  end,
}

local lsp_installer = require("nvim-lsp-installer")

-- from https://github.com/williamboman/nvim-lsp-installer/blob/b14bd0c5d75ca9da91d7675e98b89450b08f0143/lua/nvim-lsp-installer/extras/tsserver.lua
-- also see https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils
function send_client_request(client_name, ...)
    for _, client in pairs(vim.lsp.get_active_clients()) do
        if client.name == client_name then
            client.request(...)
        end
    end
end

function typescript_rename_file(old, new)
    local old_uri = vim.uri_from_fname(old)
    local new_uri = vim.uri_from_fname(new)

    send_client_request("tsserver", "workspace/executeCommand", {
        command = "_typescript.applyRenameFile",
        arguments = {
            {
                sourceUri = old_uri,
                targetUri = new_uri,
            },
        },
    })
end

function rename_file_command()
  local old_name = vim.fn.expand('%:p:.')
  local new_name = vim.fn.input("File: ", old_name, "file")
  typescript_rename_file(old_name, new_name)
end

lsp_installer.on_server_ready(function(server)
    local opts = {
      capabilities = capabilities,
      on_attach = function()
        vim.keymap.set("n", "K", vim.lsp.buf.hover, {buffer=0})
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, {buffer=0})
        vim.keymap.set("n", "gD", vim.lsp.buf.type_definition, {buffer=0})
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {buffer=0})
        vim.keymap.set("n", "gr", vim.lsp.buf.references, {buffer=0})
        vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, {buffer=0})
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {buffer=0})
        vim.keymap.set("n", "<leader>cR", rename_file_command, {buffer=0})

        vim.keymap.set("n", "<leader>df", "<cmd>Telescope diagnostics<cr>", {buffer=0})
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next, {buffer=0})
        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {buffer=0})
      end,
    }

    if server.name == "tsserver" then
    end

    server:setup(opts)
end)

local cmp = require'cmp'

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
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
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})
