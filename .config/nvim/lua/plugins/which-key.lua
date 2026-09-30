-- ~/.config/nvim/lua/plugins/which-key.lua
-- Popup that shows available keybindings (and their desc) as you type.
-- The `spec` below only names the GROUPS -- the individual keys come from the
-- `desc` fields on the mappings themselves, so nothing is duplicated here.
return {
  "folke/which-key.nvim",
  event = "VeryLazy", -- load after startup, before you'd need it
  opts = {
    spec = {
      { "<leader>g", group = "git (fugitive)" },
      { "<leader>h", group = "hunk (gitsigns)" },
      { "<leader>f", group = "find" },
      { "<leader>b", group = "buffer" },
      { "<leader>t", group = "terminal / toggle" },
    },
  },
}
