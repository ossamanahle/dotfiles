-- ~/.config/nvim-k8s/lua/plugins/indent-blankline.lua
-- Vertical guides on every indent level -- the main reason this exists is
-- deeply nested k8s manifests and helm values.
--
-- Differs from the ~/.config/nvim copy in one important way: `scope` is off.
-- Scope highlighting is treesitter-powered, and this config has no treesitter
-- (no tree-sitter-cli / C compiler in the container). ibl degrades silently
-- rather than erroring, but leaving it enabled would just be dead config, so
-- it is explicitly disabled and documented here instead.
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },

  config = function()
    -- Re-applied on ColorScheme because gruvbox clears custom groups on load.
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

      -- No treesitter in this config; see header.
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
