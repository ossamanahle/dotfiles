return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000, -- load first so colors apply
  config = function()
    require("gruvbox").setup({
      contrast = "", -- "hard", "soft", or "" (medium)
      transparent_mode = false,
    })
    vim.o.background = "dark"
    vim.cmd.colorscheme("gruvbox")
  end,
}
