-- Leader (must be set before lazy.nvim loads)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- Editing
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.scrolloff = 8
vim.opt.smoothscroll = true    -- needs wrap
vim.opt.scroll = 15           -- <C-d>/<C-u> distance
vim.opt.signcolumn = "yes"
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus" -- needs wl-clipboard
vim.opt.undofile = true
vim.opt.termguicolors = true   -- required by gruvbox

-- Diff (replace default linematch:40 rather than appending a second one)
vim.opt.diffopt:remove("linematch:40")
vim.opt.diffopt:append("linematch:60")        -- align lines within hunks
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:append("vertical")
vim.opt.fillchars:append("diff:╱")

-- Mappings
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })

-- Scrolling (keep the cursor centered)
vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })

vim.keymap.set("n", "n", "nzzzv", { desc = "Next match (centered)" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Prev match (centered)" })

vim.keymap.set({ "n", "v" }, "<C-e>", "3<C-e>", { desc = "Scroll down 3 lines" })
vim.keymap.set({ "n", "v" }, "<C-y>", "3<C-y>", { desc = "Scroll up 3 lines" })

vim.keymap.set({ "n", "v" }, "<S-Down>", "5gj", { desc = "Down 5 lines" })
vim.keymap.set({ "n", "v" }, "<S-Up>", "5gk", { desc = "Up 5 lines" })

-- j/k move by screen line, but counts (10j) stay linewise
vim.keymap.set({ "n", "v" }, "j", function()
  return vim.v.count == 0 and "gj" or "j"
end, { expr = true, desc = "Down (screen line aware)" })
vim.keymap.set({ "n", "v" }, "k", function()
  return vim.v.count == 0 and "gk" or "k"
end, { expr = true, desc = "Up (screen line aware)" })

-- Keep selection after indenting
vim.keymap.set("v", "<", "<gv", { desc = "Indent left, keep selection" })
vim.keymap.set("v", ">", ">gv", { desc = "Indent right, keep selection" })

-- Terminal
vim.keymap.set("n", "<leader>tt", "<cmd>botright split | resize 12 | terminal<CR>i",
  { desc = "Open terminal (horizontal split)" })
vim.keymap.set("n", "<leader>tv", "<cmd>vsplit | terminal<CR>i",
  { desc = "Open terminal (vertical split)" })
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Buffers
vim.keymap.set("n", "<leader>]", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>[", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bb", "<C-^>", { desc = "Toggle last buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete (close) buffer" })
vim.keymap.set("n", "<leader>bl", "<cmd>buffers<CR>", { desc = "List buffers" })

-- Diagnostics (0.11+ hides inline text by default)
vim.diagnostic.config({
  virtual_text = { spacing = 2, prefix = "●" },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
})
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show error under cursor (popup)" })
vim.keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Next error/warning" })
vim.keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Previous error/warning" })
vim.keymap.set("n", "<leader>xl", vim.diagnostic.setloclist, { desc = "List errors in this file" })
vim.keymap.set("n", "<leader>xx", vim.diagnostic.setqflist, { desc = "List errors in all open files" })

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Plugins from lua/plugins/
require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "gruvbox" } },
  checker = { enabled = true },
})
