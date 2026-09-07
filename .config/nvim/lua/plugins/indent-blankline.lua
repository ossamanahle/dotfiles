-- Vertical guides on every indent level, plus a highlighted "current scope"
-- line so you can see which YAML/JSON/Python block the cursor lives in.
return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",                   -- the module name differs from the repo name
  event = { "BufReadPost", "BufNewFile" },

  config = function()
    -- Custom highlight groups. Defined inside a ColorScheme autocmd so they
    -- survive a `:colorscheme` switch (gruvbox resets highlights on load).
    local function set_hl()
      -- Faint guides for the inactive indent levels...
      vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3c3836" })
      -- ...and a brighter one for the scope under the cursor.
      vim.api.nvim_set_hl(0, "IblScope", { fg = "#7c6f64" })
    end

    set_hl()
    vim.api.nvim_create_autocmd("ColorScheme", {
      group = vim.api.nvim_create_augroup("IblHighlights", { clear = true }),
      callback = set_hl,
    })

    require("ibl").setup({
      indent = {
        char = "│",              -- try "▏" for a thinner line
        highlight = "IblIndent",
        -- Don't draw a guide on lines that are only whitespace.
        smart_indent_cap = true,
      },

      whitespace = {
        remove_blankline_trail = true,
      },

      scope = {
        enabled = true,
        char = "│",
        highlight = "IblScope",
        show_start = false,       -- set true for an underline on the opening line
        show_end = false,
        show_exact_scope = false,
        -- Treesitter node types that count as a "scope" for these languages.
        -- YAML's block mappings/sequences are what make nesting readable.
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

    -- Toggle the guides off when they get in the way (e.g. copying text out).
    vim.keymap.set("n", "<leader>ti", "<cmd>IBLToggle<CR>", { desc = "Toggle indent guides" })
  end,
}
