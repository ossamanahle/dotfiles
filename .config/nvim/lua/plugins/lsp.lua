-- ~/.config/nvim/lua/plugins/lsp.lua
-- Mason (installs LSP servers) + mason-lspconfig + nvim-lspconfig.
-- Requires Neovim >= 0.11. Installed servers are auto-enabled
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
      "lua_ls",       -- Lua
      "pyright",      -- Python            (needs Node)
      "clangd",       -- C and C++         (one server covers both)
      "ts_ls",        -- JavaScript & TypeScript (one server covers both; needs node)
      "jdtls",        -- Java              (needs a JDK installed system-wide)

      -- Web / config formats. vscode-langservers-extracted ships html, cssls
      -- and jsonls as one Mason package, so these three are ~free together.
      "html",         -- HTML              (needs Node)
      "cssls",        -- CSS               (needs Node)
      "jsonls",       -- JSON              (needs Node)
      "yamlls",       -- YAML              (needs Node; schema-aware)
      "taplo",        -- TOML              (standalone binary)

      -- Shell. bashls covers both `sh`/`bash` and zsh buffers.
      -- Diagnostics come from shellcheck, installed separately below.
      "bashls",       -- Bash / Zsh        (needs Node)

      -- SQL. Note: sqlls does syntax/completion only; it has no notion of your
      -- actual database schema unless you configure a connection.
      "sqlls",        -- SQL               (needs Node)

      -- NOTE: rust_analyzer is deliberately absent. Mason's copy conflicts with
      -- the toolchain-managed one and needs a working rustup install, which
      -- this machine does not have (no rustc/cargo on PATH). Install Rust with
      -- `rustup component add rust-analyzer`, then add "rust_analyzer" here.
    },
  },
  config = function(_, opts)
    -- Tell language servers what completion features the client (blink.cmp)
    -- supports, so they send richer suggestions. Applies to every server.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    require("mason-lspconfig").setup(opts)

    -- bashls shells out to shellcheck for diagnostics; without it you get
    -- completion and hover but no warnings. shellcheck is a Mason *tool*, not
    -- an LSP, so mason-lspconfig's ensure_installed can't reach it -- install
    -- it yourself once with:  :MasonInstall shellcheck

    -- Treat zsh buffers as shell for bashls. Without this, bashls never
    -- attaches to .zsh files because its filetype list is sh/bash only.
    vim.lsp.config("bashls", {
      filetypes = { "sh", "bash", "zsh" },
    })

    -- yamlls disables its own formatter by default, and needs schema hints to
    -- be genuinely useful. SchemaStore-backed schemas are opt-in.
    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          validate = true,
          keyOrdering = false, -- don't complain about unsorted keys
          schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
        },
      },
    })

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
