-- Indent guides with the current scope highlighted
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },

  config = function()
    -- In a ColorScheme autocmd so they survive :colorscheme
    local function set_hl()
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3c3836" })
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#7c6f64" })
    end

    set_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("IblHighlights", { clear = true }),
      callback = set_hl,
    })

    require("ibl").setup({
      indent = {
        char = "│",
        highlight = "IblIndent",
        smart_indent_cap = true,
      },

      whitespace = {
        remove_blankline_trail = true,
      },

      scope = {
        enabled = true,
        char = "│",
        highlight = "IblScope",
        show_start = false,
        show_end = false,
        show_exact_scope = false,
        -- Treesitter nodes that count as a scope
        include = {
          node_type = {
            yaml = { "block_mapping_pair", "block_sequence_item" },
            ["*"] = { "@class", "@function", "@method", "@block", "@conditional", "@loop" },
          },
        },
      },

      exclude = {
        filetypes = {
          "help",
          "lazy",
          "mason",
          "neo-tree",
          "Trouble",
          "terminal",
          "dashboard",
          "checkhealth",
          "man",
          "gitcommit",
        },
        buftypes = { "terminal", "nofile", "quickfix", "prompt" },
      },
    })

    vim.keymap.set("n", "<leader>ti", "<cmd>IBLToggle<CR>", { desc = "Toggle indent guides" })
  end,
}
