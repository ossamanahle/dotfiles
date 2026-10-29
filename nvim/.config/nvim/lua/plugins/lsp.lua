-- LSP via Mason. Installed servers are auto-enabled (nvim 0.11+).
return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  opts = {
    -- Auto-installed. lspconfig names, not Mason package names.
    ensure_installed = {
      "lua_ls",
      "pyright",
      "clangd",
      "ts_ls",
      "jdtls",  -- needs a JDK

      "html",
      "cssls",
      "jsonls",
      "yamlls",
      "taplo",
      "nil_ls",
      "bashls",
      "sqlls",
      -- No rust_analyzer: install via `rustup component add rust-analyzer`
    },
  },
  config = function(_, opts)
    -- Advertise blink.cmp completion features to every server
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    require("mason-lspconfig").setup(opts)

    -- bashls diagnostics need shellcheck: :MasonInstall shellcheck

    -- Let bashls attach to zsh files
    vim.lsp.config("bashls", {
      filetypes = { "sh", "bash", "zsh" },
    })

    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          validate = true,
          keyOrdering = false,
          schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
        },
      },
    })

    -- Keymaps once a server attaches
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
