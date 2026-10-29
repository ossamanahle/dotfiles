-- Only group names here; keys come from each mapping's desc
return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>g", group = "git (fugitive)" },
      { "<leader>h", group = "hunk (gitsigns)" },
      { "<leader>f", group = "find (telescope)" },
      { "<leader>b", group = "buffer" },
      { "<leader>t", group = "terminal / toggle" },
      { "<leader>x", group = "diagnostics (errors)" },
    },
  },
}
