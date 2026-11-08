-- Servers come from PATH, never from nvim: dev.nix on the host, the image in
-- a container. A server is enabled only if its binary exists, so this one
-- config fits every machine and each box decides its own servers.
local servers = {
  -- lspconfig name = binary
  lua_ls   = "lua-language-server",
  pyright  = "pyright-langserver",
  clangd   = "clangd",
  ts_ls    = "typescript-language-server",
  jdtls    = "jdtls",
  html     = "vscode-html-language-server",
  cssls    = "vscode-css-language-server",
  jsonls   = "vscode-json-language-server",
  yamlls   = "yaml-language-server",
  taplo    = "taplo",
  nil_ls   = "nil",
  bashls   = "bash-language-server",
  dockerls = "docker-langserver",
}

return {
  "neovim/nvim-lspconfig",
  config = function()
    -- Advertise blink.cmp completion features to every server
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- Let bashls attach to zsh files (diagnostics need shellcheck on PATH)
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

    for name, bin in pairs(servers) do
      if vim.fn.executable(bin) == 1 then
        vim.lsp.enable(name)
      end
    end

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
