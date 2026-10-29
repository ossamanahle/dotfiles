-- Fuzzy finder, mainly for :Telescope keymaps
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Find keymaps" },
  },
}
