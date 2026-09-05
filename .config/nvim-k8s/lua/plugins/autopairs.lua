-- ~/.config/nvim/lua/plugins/autopairs.lua
-- Auto-close brackets/quotes, and <CR> between braces opens an indented block
-- (VS Code-style). Works with blink.cmp out of the box.
return {
  "windwp/nvim-autopairs",
  event = "InsertEnter", -- load lazily, only when you start typing
  opts = {},             -- defaults are good: map_cr = true gives the Enter behavior
}
