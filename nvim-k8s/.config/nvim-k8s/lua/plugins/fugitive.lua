-- Git from inside nvim
return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G" },
  keys = {
    { "<leader>gs", "<cmd>Git<CR>",       desc = "Git status" },
    { "<leader>gb", "<cmd>Git blame<CR>", desc = "Git blame" },
    { "<leader>gd", "<cmd>Gdiffsplit<CR>", desc = "Git diff (split)" },
  },
}
