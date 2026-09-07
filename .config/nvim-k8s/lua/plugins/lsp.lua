-- ~/.config/nvim-k8s/lua/plugins/lsp.lua
-- Trimmed for the k3s control container: only the languages you actually
-- edit here. No pyright/clangd/jdtls -- there is no Python, C or Java in
-- this container, and Mason would fail installing servers for them.
--
-- All four servers below are node-based, so the image needs nodejs.
return {
  "mason-org/mason-lspconfig.nvim",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = {
      "lua_ls",     -- this config itself
      "yamlls",     -- k8s manifests, helm values, compose files
      "bashls",     -- shell scripts
      "dockerls",   -- Dockerfiles
      "jsonls",     -- kubeconfig-adjacent json, package.json
    },
  },
  config = function(_, opts)
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    require("mason-lspconfig").setup(opts)

    -- bashls needs shellcheck for diagnostics; it's a Mason *tool*, not an LSP,
    -- so ensure_installed above can't reach it:  :MasonInstall shellcheck

    -- Treat zsh buffers as shell for bashls, whose default filetype list is
    -- sh/bash only.
    vim.lsp.config("bashls", {
      filetypes = { "sh", "bash", "zsh" },
    })

    -- The payload of this config. SchemaStore gives real validation and
    -- completion for k8s manifests, helm values and compose files -- without
    -- it yamlls only checks that the YAML parses at all.
    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          validate = true,
          keyOrdering = false, -- don't complain about unsorted keys
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
