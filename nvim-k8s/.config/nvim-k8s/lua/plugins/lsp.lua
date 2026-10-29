-- Only what the container needs. All servers are node-based.
return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = {
      "lua_ls",
      "yamlls", -- k8s, helm, compose
      "bashls",
      "dockerls",
      "jsonls",
    },
  },
  config = function(_, opts)
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    require("mason-lspconfig").setup(opts)

    -- bashls diagnostics need shellcheck: :MasonInstall shellcheck

    -- Let bashls attach to zsh files
    vim.lsp.config("bashls", {
      filetypes = { "sh", "bash", "zsh" },
    })

    -- SchemaStore validates k8s, helm and compose files
    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          validate = true,
          keyOrdering = false,
          schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
        },
      },
    })

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
