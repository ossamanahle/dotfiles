-- ~/.config/nvim/lua/plugins/blink.lua
-- Autocomplete. blink.cmp is the modern, fast completion engine (2026 standard).
return {
  "saghen/blink.cmp",
  version = "1.*", -- pin to a release tag so a prebuilt binary is downloaded (no Rust needed)
  dependencies = {
    "rafamadriz/friendly-snippets", -- a big library of ready-made snippets
  },
  opts = {
    -- "super-tab": press Tab to accept the highlighted suggestion (VS Code-like).
    --   <Tab>/<S-Tab> = next/prev & accept, <C-Space> = open menu, <C-e> = dismiss.
    -- Prefer Enter-to-accept? change to preset = "enter". Ctrl-y always accepts too.
    keymap = { preset = "super-tab" },

    appearance = { nerd_font_variant = "mono" }, -- icon spacing (needs a Nerd Font)

    completion = {
      documentation = { auto_show = true }, -- show docs popup next to the menu
      menu = { draw = { treesitter = { "lsp" } } },
    },

    -- Where suggestions come from, in priority order.
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },

    fuzzy = { implementation = "prefer_rust_with_warning" }, -- typo-tolerant matching
  },
}
