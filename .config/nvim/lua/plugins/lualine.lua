-- ~/.config/nvim/lua/plugins/lualine.lua
-- Minimal, readable statusline. One global bar across the bottom.
return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- filetype icons (optional but nice)
  event = "VeryLazy",
  opts = {
    options = {
      theme = "gruvbox",
      globalstatus = true,        -- a single statusline for the whole editor (cleaner)
      icons_enabled = true,
      -- Minimal look: no powerline arrows, thin separators between components.
      section_separators = { left = "", right = "" },
      component_separators = { left = "│", right = "│" },
    },
    sections = {
      -- Left
      lualine_a = { "mode" },                       -- NORMAL / INSERT / VISUAL …
      lualine_b = { "branch", "diff", "diagnostics" }, -- git branch + changes + LSP errors
      lualine_c = { { "filename", path = 1 } },     -- relative path to the file
      -- Right
      lualine_x = { "filetype" },                   -- e.g. lua, rust, python
      lualine_y = { "progress" },                   -- % through the file
      lualine_z = { "location" },                   -- line:column
    },
    -- When a window is inactive, show just the filename — keeps things quiet.
    inactive_sections = {
      lualine_c = { { "filename", path = 1 } },
      lualine_x = { "location" },
    },
  },
}
