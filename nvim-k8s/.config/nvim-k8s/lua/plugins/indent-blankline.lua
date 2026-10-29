-- Indent guides. Scope is off: it needs treesitter, which this config lacks.
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },

  config = function()
    -- In a ColorScheme autocmd so they survive :colorscheme
    local function set_hl()
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3c3836" })
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

      scope = { enabled = false },

      exclude = {
        filetypes = {
          "help", "lazy", "mason", "neo-tree", "checkhealth",
          "man", "gitcommit", "dashboard",
        },
        buftypes = { "terminal", "nofile", "quickfix", "prompt" },
      },
    })

    vim.keymap.set("n", "<leader>ti", "<cmd>IBLToggle<CR>", { desc = "Toggle indent guides" })
  end,
}
