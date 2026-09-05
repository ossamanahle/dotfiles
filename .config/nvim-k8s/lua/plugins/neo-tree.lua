-- ~/.config/nvim/lua/plugins/neo-tree.lua
-- File explorer sidebar (the modern Lua replacement for NERDTree).
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- file-type icons (needs a Nerd Font to render)
    "MunifTanjim/nui.nvim",
  },
  cmd = "Neotree", -- lazy-load when the :Neotree command is first used
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle file explorer" },
  },
  opts = {
    close_if_last_window = true, -- don't leave a lone tree window open
    filesystem = {
      follow_current_file = { enabled = true }, -- highlight the file you're editing
      use_libuv_file_watcher = true,            -- auto-refresh on external changes
      filtered_items = { hide_dotfiles = false }, -- show dotfiles by default
    },
    window = { width = 32 },
  },
}
