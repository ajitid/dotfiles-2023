local ls = require "luasnip"
local types = require "luasnip.util.types"

ls.config.set_config {
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = true,

  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = "TextChanged,TextChangedI",

  -- Autosnippets:
  enable_autosnippets = true,

  -- Crazy highlights!!
  -- #vid3
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<-", "Error" } },
      },
    },
  },
}

-- <c-j> is my expansion key
-- this will expand the current item or jump to the next item within the snippet
vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end, { silent = true })

-- <c-k> is my jump backwards key
-- this always moves to the previous item within the snippet
vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2)
vim.keymap.set("i", "<c-l>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end)

-- ------------

-- This is a snippet creator
-- s(<trigger>, <nodes>)
local s = ls.s

-- This is a format node.
-- It takes a format string, and a list of nodes
-- fmt(<fmt_string>, {...nodes})
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local l = require("luasnip.extras").lambda
local dl = require("luasnip.extras").dynamic_lambda
local ne = require("luasnip.extras").nonempty

local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node

-- Repeats a node
-- rep(<position>)
local rep = require("luasnip.extras").rep

-- for reason, see https://stackoverflow.com/a/50478498/7683365
table.unpack = table.unpack or unpack

local date = function() return {os.date('%Y-%m-%d')} end

local js_common = {
  ls.parser.parse_snippet("prn", "console.log($0)"),
  ls.parser.parse_snippet("prnd", "console.log(\"dbg:\", $0)"),
  s("rus", fmt("const [{}, {}] = useState({})", { i(1), dl(2, "set" .. l._1:gsub("^%l", string.upper), 1), i(3) })),
}

ls.add_snippets(nil, {
  all = {
    -- Available in any filetype
  },
  go = {
    s("prn", fmt("fmt.Println({})", i(1))),
    s("fn", fmta("func <>(<>) <><>{<>\n}", {i(1), i(2), i(3), ne(3, " ", ""), i(0)})),
    ls.parser.parse_snippet("pt", 'panic("TODO(ajit)")'),
  },
  lua = {
    -- prefer s( over ls.parser.parse_snippet(
    s("req", fmt("local {} = require('{}')", { i(1, "default"), rep(1) })),
    ls.parser.parse_snippet("lf", "local $1 = function($2)\n  $0\nend"),
  },
  javascript = { table.unpack(js_common) },
  typescript = { table.unpack(js_common), },
  typescriptreact = {
    table.unpack(js_common),
    -- TODO capitalize doesn't work
  },
  astro = { table.unpack(js_common), },
  markdown = {
    s("!", fmt([[
      ---
      title: {}
      created: {}
      ---

      {}
      ]],
      { i(1), f(date, {}), i(0) })
    )
  }
})

