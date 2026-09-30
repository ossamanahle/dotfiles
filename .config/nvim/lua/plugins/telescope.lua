-- ~/.config/nvim/lua/plugins/telescope.lua
-- Fuzzy finder. Used here for `:Telescope keymaps` (a flat, searchable list of
-- every mapping, unlike which-key's prefix-tree popup) and for the git pickers,
-- which are the nicest way to browse branches / commits / stashes.
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope", -- lazy-load when the :Telescope command is first used
  keys = {
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Find keymaps" },

    -- === Git pickers ===
    -- In git_branches:  <CR> checkout, <C-d> delete, <C-r> rebase, <C-a> create
    -- In git_status:    <Tab> stage/unstage the file under the cursor
    -- In git_commits:   <CR> checkout that commit
    { "<leader>fb", "<cmd>Telescope git_branches<CR>", desc = "Git branches (checkout)" },
    { "<leader>fc", "<cmd>Telescope git_commits<CR>",  desc = "Git commits (repo)" },
    { "<leader>fC", "<cmd>Telescope git_bcommits<CR>", desc = "Git commits (this buffer)" },
    { "<leader>fS", "<cmd>Telescope git_stash<CR>",    desc = "Git stashes (apply)" },
    { "<leader>fg", "<cmd>Telescope git_status<CR>",   desc = "Git status (changed files)" },
  },
}
