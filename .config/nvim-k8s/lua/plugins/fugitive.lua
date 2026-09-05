-- ~/.config/nvim/lua/plugins/fugitive.lua
-- vim-fugitive: run git from inside neovim.
return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G" }, -- lazy-load: only pull it in when you run :Git
  keys = {
    { "<leader>gs", "<cmd>Git<CR>",       desc = "Git status" },
    { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
    { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git diff (split)" },
  },
}
