local diagnostics = vim.lsp.diagnostic

local M = {}

function M.echo_line_diagnostics(bufnr, line_nr, client_id)
    bufnr = bufnr or 0
    line_nr = line_nr or (vim.api.nvim_win_get_cursor(0)[1] - 1)

    local line_diagnostics = diagnostics.get_line_diagnostics(bufnr, line_nr, {}, client_id)
    if vim.tbl_isempty(line_diagnostics) then return end

    local lines = {}

    for i, diagnostic in ipairs(line_diagnostics) do
        local prefix_text = diagnostic.source or '(unknown)'
        if diagnostic.code then
          prefix_text = prefix_text .. ' ' .. diagnostic.code .. '\n'
        end
        local prefix = string.format("%d. %s", i, prefix_text)
        if i ~= 1 then
            prefix = "\n" .. prefix
        end

        local message_lines = vim.split(diagnostic.message, '\n')

        table.insert(lines, {prefix..message_lines[1], 'None'})
        for j = 2, #message_lines do
            table.insert(lines, {message_lines[j], 'None'})
        end
    end

    vim.api.nvim_echo(lines, false, {})
end

return M
