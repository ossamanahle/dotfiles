-- Autocomplete
return {
  "saghen/blink.cmp",
  version = "1.*", -- release tag = prebuilt binary, no Rust needed
  dependencies = {
    "rafamadriz/friendly-snippets",
  },
  opts = {
    -- Tab accepts, <C-Space> opens, <C-e> dismisses
    keymap = { preset = "super-tab" },

    appearance = { nerd_font_variant = "mono" },

    completion = {
      documentation = { auto_show = true },
      menu = { draw = { treesitter = { "lsp" } } },
    },

    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
