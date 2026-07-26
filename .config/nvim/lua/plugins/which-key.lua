-- ~/.config/nvim/lua/plugins/which-key.lua
-- Popup that shows available keybindings (and their desc) as you type.
return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- load after startup, before you'd need it
  opts = {},          -- defaults are sane; the desc fields on our keymaps show up automatically
}
