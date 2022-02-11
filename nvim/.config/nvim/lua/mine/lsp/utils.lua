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

return M
