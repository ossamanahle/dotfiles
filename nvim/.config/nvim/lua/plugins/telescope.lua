-- In a picker: <C-q> to quickfix, ? (normal) or <C-/> (insert) for all keys
return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>",  desc = "Find files" },
    { "<leader><leader>", "<cmd>Telescope buffers sort_mru=true ignore_current_buffer=true<CR>", desc = "Switch buffer" },
    { "<leader>fr", "<cmd>Telescope oldfiles only_cwd=true<CR>", desc = "Recent files (this project)" },
    { "<leader>fz", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy search in this file" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>",   desc = "Search Neovim help" },
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Errors/warnings (all buffers)" },
    { "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Symbols in file (functions...)" },
    { "<leader>f.", "<cmd>Telescope resume<CR>",      desc = "Reopen last picker" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>",     desc = "Find keymaps" },
    { "<leader>fn", function() require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") }) end,
      desc = "Find Neovim config file" },

    -- Git (branches: <C-d> delete, <C-a> create; status: <Tab> stage)
    { "<leader>fb", "<cmd>Telescope git_branches<CR>", desc = "Git branches (checkout)" },
    { "<leader>fc", "<cmd>Telescope git_commits<CR>",  desc = "Git commits (repo)" },
    { "<leader>fC", "<cmd>Telescope git_bcommits<CR>", desc = "Git commits (this buffer)" },
    { "<leader>fS", "<cmd>Telescope git_stash<CR>",    desc = "Git stashes (apply)" },
    { "<leader>fg", "<cmd>Telescope git_status<CR>",   desc = "Git status (changed files)" },
  },
  opts = function()
    local actions = require("telescope.actions")
    local layout = require("telescope.actions.layout")
    local action_state = require("telescope.actions.state")

    -- <CR> in git pickers opens the full diff in a new tab; original actions move to <M-...>
    local function full_diff(build_cmd)
      return function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        if not entry then return end
        actions.close(prompt_bufnr)
        vim.cmd(build_cmd(entry))
      end
    end
    local open_commit = full_diff(function(e) return "Gtabedit " .. e.value end)
    -- A stash is a merge commit: diff against its first parent
    local open_stash = full_diff(function(e)
      return "tab Git --paginate show --diff-merges=first-parent " .. vim.fn.fnameescape(e.value)
    end)
    -- Untracked files just open
    local open_status = full_diff(function(e)
      if e.status and e.status:find("?", 1, true) then
        return "tabedit " .. vim.fn.fnameescape(e.path)
      end
      return "tab Git --paginate diff HEAD -- " .. vim.fn.fnameescape(e.path)
    end)
    local function diff_keys(fn, extra)
      local i, n = { ["<CR>"] = fn }, { ["<CR>"] = fn }
      for key, action in pairs(extra or {}) do
        i[key], n[key] = action, action
      end
      return { mappings = { i = i, n = n } }
    end

    -- horizontal | vertical | flex | center | bottom_pane
    local default_layout = "flex"

    return {
      defaults = {
        layout_strategy = default_layout,
        -- <M-l> cycles through these
        cycle_layout_list = { "horizontal", "vertical", "center", "bottom_pane" },
        prompt_prefix = "  ",
        selection_caret = " ",
        path_display = { "truncate" },
        sorting_strategy = "ascending",
        layout_config = {
          prompt_position = "top",
          width = 0.9,
          height = 0.85,
          horizontal = { preview_width = 0.55 },
          vertical = { preview_height = 0.5, mirror = true },
          flex = { flip_columns = 140 },
          center = { width = 0.6, height = 0.4 },
          bottom_pane = { height = 0.45 },
        },
        file_ignore_patterns = { "%.git/", "node_modules/", "%.cache/" },
        mappings = {
          i = {
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
            ["<M-p>"] = layout.toggle_preview,
            ["<M-l>"] = layout.cycle_layout_next,
          },
          n = {
            ["q"] = actions.close,
            ["<M-p>"] = layout.toggle_preview,
            ["<M-l>"] = layout.cycle_layout_next,
          },
        },
      },
      pickers = {
        find_files = { hidden = true },
        git_commits = diff_keys(open_commit, { ["<M-c>"] = actions.git_checkout }),
        git_bcommits = diff_keys(open_commit, {
          ["<M-c>"] = actions.git_checkout_current_buffer,
        }),
        git_stash = diff_keys(open_stash, { ["<M-a>"] = actions.git_apply_stash }),
        git_status = diff_keys(open_status, { ["<M-e>"] = actions.select_default }),
        buffers = {
          mappings = {
            i = { ["<C-d>"] = actions.delete_buffer },
            n = { ["dd"] = actions.delete_buffer },
          },
        },
      },
    }
  end,
}
