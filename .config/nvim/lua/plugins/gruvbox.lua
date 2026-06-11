-- ~/.config/nvim/lua/plugins/gruvbox.lua
-- Gruvbox colorscheme.
return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000, -- load before other plugins so colors are set first
  config = function()
    require("gruvbox").setup({
      contrast = "", -- "hard", "soft", or "" (medium)
      transparent_mode = false,
    })
    vim.o.background = "dark" -- change to "light" if you prefer the light variant
    vim.cmd.colorscheme("gruvbox")
  end,
}
