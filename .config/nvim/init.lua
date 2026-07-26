-- ~/.config/nvim/init.lua
-- Core settings + plugin manager bootstrap.

-- === Leader key (MUST be set before lazy.nvim loads) ===
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- === Line numbers ===
vim.opt.number = true          -- absolute number on the current line
vim.opt.relativenumber = true  -- relative numbers on the others (great for motions)

-- === Indentation ===
vim.opt.expandtab = true       -- insert spaces when you press Tab
vim.opt.shiftwidth = 2         -- size of an indent
vim.opt.tabstop = 2            -- how many columns a Tab counts for
vim.opt.softtabstop = 2
vim.opt.smartindent = true     -- auto-indent new lines sensibly

-- === Search ===
vim.opt.ignorecase = true      -- case-insensitive search...
vim.opt.smartcase = true       -- ...unless your query has a capital letter
vim.opt.hlsearch = true        -- highlight matches
vim.opt.incsearch = true       -- show matches as you type

-- === Editing quality of life ===
vim.opt.wrap = true            -- soft-wrap long lines
vim.opt.linebreak = true       -- wrap at word boundaries, not mid-word
vim.opt.breakindent = true     -- wrapped lines keep the original indent
vim.opt.scrolloff = 8          -- keep 8 lines visible above/below the cursor
vim.opt.signcolumn = "yes"     -- reserve the gutter so text doesn't jump
vim.opt.mouse = "a"            -- enable the mouse in all modes
vim.opt.clipboard = "unnamedplus" -- use the system clipboard (needs wl-clipboard)
vim.opt.undofile = true        -- persist undo history across sessions
vim.opt.termguicolors = true   -- enable 24-bit colors (required by gruvbox)

-- === A few handy mappings ===
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")                          -- clear search highlight
vim.keymap.set("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })

-- === Terminal ===
vim.keymap.set("n", "<leader>tt", "<cmd>botright split | resize 12 | terminal<CR>i",
  { desc = "Open terminal (horizontal split)" })
vim.keymap.set("n", "<leader>tv", "<cmd>vsplit | terminal<CR>i",
  { desc = "Open terminal (vertical split)" })
vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { desc = "Exit terminal mode" }) -- back to normal mode

-- === Buffers ===
vim.keymap.set("n", "<leader>]", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>[", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bb", "<C-^>", { desc = "Toggle last buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete (close) buffer" })
vim.keymap.set("n", "<leader>bl", "<cmd>buffers<CR>", { desc = "List buffers" })

-- === Bootstrap lazy.nvim (installs itself on first launch) ===
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

-- === Load plugins from lua/plugins/ ===
require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "gruvbox" } }, -- used while plugins install on first run
  checker = { enabled = true },              -- periodically check for plugin updates
})
