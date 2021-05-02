local M = {}
local loop = vim.loop
local api = vim.api
local results = {}
local function onread(err, data)
  if err then
    -- print('ERROR: ', err)
    -- TODO handle err
    -- TODO also handle when list is empty
    -- check where `copen` is called (update: cwindow is used instead of copen)
  end
  if data then
    local vals = vim.split(data, "\n")
    for _, d in pairs(vals) do
      if d == "" then goto continue end
      table.insert(results, d)
      ::continue::
    end
  end
end
function M.asyncGrep(term)
  local stdout = vim.loop.new_pipe(false)
  local stderr = vim.loop.new_pipe(false)
  local function setQF()
    vim.fn.setqflist({}, 'r', {title = 'Search Results', lines = results})
    api.nvim_command('cwindow')
    if #results == 0 then
      print('no results for ' .. term)
    else
      print(#results .. ' results found')
    end
    local count = #results
    for i=0, count do results[i]=nil end -- clear the table for the next search
  end
  local query = vim.split(term, ' IN ')
  local search_term = query[1]
  local dir_to_search_in = query[2] and query[2] or '.'
  print(search_term, dir_to_search_in)
  handle = vim.loop.spawn('rg', {
    args = {search_term, dir_to_search_in, '--vimgrep', '--smart-case'},
    stdio = {nil,stdout,stderr}
  },
  vim.schedule_wrap(function()
    stdout:read_stop()
    stderr:read_stop()
    stdout:close()
    stderr:close()
    handle:close()
    setQF()
  end
  )
  )
  vim.loop.read_start(stdout, onread)
  vim.loop.read_start(stderr, onread)
end
return M
