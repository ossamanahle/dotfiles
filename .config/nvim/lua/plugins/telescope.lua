-- ~/.config/nvim/lua/plugins/telescope.lua
-- Fuzzy finder. Used here mainly for `:Telescope keymaps` — a flat,
-- searchable list of every mapping, unlike which-key's prefix-tree popup.
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope", -- lazy-load when the :Telescope command is first used
  keys = {
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
  },
}
