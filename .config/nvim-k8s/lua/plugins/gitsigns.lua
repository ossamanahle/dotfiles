return {
  "lewis6991/gitsigns.nvim",

  config = function()
    require("gitsigns").setup({
      signs = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "┆" },
      },

      -- No `untracked` here: an untracked file has nothing in the index,
      -- so a staged-untracked hunk can't exist.
      signs_staged = {
        add = { text = "┃" },
        change = { text = "┃" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },

      signs_staged_enable = true,
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,

      watch_gitdir = {
        follow_files = true,
      },

      auto_attach = true,
      attach_to_untracked = true, -- required for the `untracked` sign above to ever render

      current_line_blame = false,

      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 100,
        use_focus = true,
      },

      -- Leading/trailing spaces keep the virtual text off the end of the line.
      current_line_blame_formatter = " <author>, <author_time:%R> - <summary> ",

      sign_priority = 6,
      update_debounce = 100,
      max_file_length = 40000,

      preview_config = {
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
      },

      on_attach = function(bufnr)
        local gitsigns = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Navigation
        map("n", "]c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gitsigns.nav_hunk("next")
          end
        end, "Next hunk")

        map("n", "[c", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gitsigns.nav_hunk("prev")
          end
        end, "Previous hunk")

        -- Actions
        -- Note: on an already-staged hunk, stage_hunk unstages it.
        map("n", "<leader>hs", gitsigns.stage_hunk, "Stage/unstage hunk")
        map("n", "<leader>hr", gitsigns.reset_hunk, "Reset hunk")

        map("v", "<leader>hs", function()
          gitsigns.stage_hunk({
            vim.fn.line("."),
            vim.fn.line("v"),
          })
        end, "Stage selected lines")

        map("v", "<leader>hr", function()
          gitsigns.reset_hunk({
            vim.fn.line("."),
            vim.fn.line("v"),
          })
        end, "Reset selected lines")

        map("n", "<leader>hS", gitsigns.stage_buffer, "Stage buffer")
        map("n", "<leader>hR", gitsigns.reset_buffer, "Reset buffer")
        map("n", "<leader>hp", gitsigns.preview_hunk, "Preview hunk (float)")
        map("n", "<leader>hi", gitsigns.preview_hunk_inline, "Preview hunk (inline)")

        map("n", "<leader>hb", function()
          gitsigns.blame_line({ full = true })
        end, "Blame line (full)")

        map("n", "<leader>hd", gitsigns.diffthis, "Diff against index")

        map("n", "<leader>hD", function()
          gitsigns.diffthis("~")
        end, "Diff against last commit")

        map("n", "<leader>hQ", function()
          gitsigns.setqflist("all")
        end, "Hunks to quickfix (repo)")

        map("n", "<leader>hq", gitsigns.setqflist, "Hunks to quickfix (buffer)")

        -- Toggles
        map("n", "<leader>tb", gitsigns.toggle_current_line_blame, "Toggle line blame")
        map("n", "<leader>tw", gitsigns.toggle_word_diff, "Toggle word diff")

        -- Text object
        map({ "o", "x" }, "ih", gitsigns.select_hunk, "Select hunk")
      end,
    })
  end,
}
