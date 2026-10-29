-- `main` branch (nvim 0.12+). Needs tree-sitter-cli and a C compiler.
-- The plugin only installs parsers; highlighting/folding are enabled below.
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false, -- doesn't support lazy-loading
  build = ":TSUpdate",
  config = function()
    -- Parser names, not filetypes. Add more with :TSInstall <name>.
    require("nvim-treesitter").install({
      -- Needed by :help and LSP hover
      "lua", "luadoc", "vim", "vimdoc", "query",
      "markdown", "markdown_inline",

      -- Keep in sync with lsp.lua
      "python",
      "c", "cpp",
      "javascript", "typescript", "tsx",
      "java",

      "rust", "sql",

      "html", "css", "json", "yaml", "toml",

      "bash", "zsh",
    })

    -- pcall: filetypes without a parser keep regex syntax
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        if not pcall(vim.treesitter.start, ev.buf) then
          return
        end

        -- Folding, opened unfolded
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldlevel = 99

        -- Experimental; remove if indenting misbehaves
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
