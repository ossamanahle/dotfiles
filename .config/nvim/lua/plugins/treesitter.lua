-- ~/.config/nvim/lua/plugins/treesitter.lua
-- nvim-treesitter, `main` branch (the 2025 rewrite; requires Neovim >= 0.12).
--
-- The plugin only downloads/compiles parsers and ships query files.
-- Neovim core does the actual highlighting, folding and injections, so we
-- switch those on ourselves in the FileType autocmd below.
--
-- Needs `tree-sitter-cli` (>= 0.26.1) and a C compiler on PATH.
--   sudo pacman -S tree-sitter-cli
return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,     -- does not support lazy-loading: plugin/filetypes.lua must
                    -- run before any buffer is attached
  build = ":TSUpdate",
  config = function()
    -- Parser names, NOT filetypes (`bash` here covers filetype `sh`, `tsx`
    -- covers `typescriptreact`, etc). Installed async on first start; already
    -- installed ones are skipped, so this is cheap on later launches.
    -- Add one at any time with :TSInstall <name>, remove with :TSUninstall.
    require("nvim-treesitter").install({
      -- Neovim itself / docs
      "lua", "luadoc", "vim", "vimdoc", "query",
      "markdown", "markdown_inline", "comment", "regex", "diff",

      -- the languages your LSP servers cover (see lua/plugins/lsp.lua)
      "python", "javascript", "jsdoc", "typescript", "tsx",
      "java", "c", "cpp",

      -- other mainstream languages
      "rust", "go", "gomod", "gosum", "ruby", "php", "c_sharp",
      "kotlin", "swift", "scala", "haskell", "zig", "elixir",
      "perl", "r", "julia", "dart", "sql",

      -- web / markup / data
      "html", "css", "scss", "json", "yaml", "toml", "xml",
      "graphql", "vue", "svelte",

      -- shell, build systems, and your dotfiles
      "bash", "zsh", "ini", "dockerfile", "make", "cmake",
      "ssh_config", "git_config", "gitcommit", "gitignore", "git_rebase",
    })

    -- One autocmd for every filetype. vim.treesitter.start() maps the
    -- filetype to a parser and errors if there is none installed -- pcall
    -- swallows that, so unsupported filetypes just keep Vim's regex syntax.
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(ev)
        if not pcall(vim.treesitter.start, ev.buf) then
          return -- no parser for this filetype; leave everything alone
        end

        -- Structural folding. foldexpr alone does nothing; foldmethod must
        -- be "expr" for Vim to call it. foldlevel keeps files opened flat
        -- instead of fully collapsed.
        vim.wo[0][0].foldmethod = "expr"
        vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.wo[0][0].foldlevel = 99

        -- Treesitter indentation is flagged EXPERIMENTAL upstream. If `=`,
        -- `o` or autoindent start misbehaving in some language, delete this.
        vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
