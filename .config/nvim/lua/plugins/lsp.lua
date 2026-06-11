-- ~/.config/nvim/lua/plugins/lsp.lua
-- Mason (installs LSP servers) + mason-lspconfig + nvim-lspconfig.
-- Requires Neovim >= 0.11 (you have 0.12). Installed servers are auto-enabled
-- via the native vim.lsp API — no manual per-server boilerplate needed.
return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} }, -- the :Mason UI to install servers/tools
    "neovim/nvim-lspconfig",               -- the LSP server configurations
  },
  opts = {
    -- Servers listed here are installed automatically on startup.
    -- Names are lspconfig names (not Mason package names). Browse more with :Mason
    ensure_installed = {
      "lua_ls",   -- Lua
      "pyright",  -- Python            (needs node — you have it)
      "clangd",   -- C and C++         (one server covers both)
      "ts_ls",    -- JavaScript & TypeScript (one server covers both; needs node)
      "jdtls",    -- Java              (needs a JDK installed system-wide — see note)
    },
  },
  config = function(_, opts)
    -- Tell language servers what completion features the client (blink.cmp)
    -- supports, so they send richer suggestions. Applies to every server.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    require("mason-lspconfig").setup(opts)

    -- Keymaps that activate once a language server attaches to a buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(event)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition, "Goto definition")
        map("gr", vim.lsp.buf.references, "Goto references")
        map("K", vim.lsp.buf.hover, "Hover docs")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
      end,
    })
  end,
}
