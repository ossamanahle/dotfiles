-- ~/.config/nvim/lua/plugins/fugitive.lua
-- vim-fugitive: run git from inside neovim.
--
-- Division of labour in this config:
--   gitsigns  -> hunk-level work inside a buffer  (<leader>h*, ]c/[c, ih)
--   fugitive  -> repo-level work: status, commit, push, log, merges (<leader>g*)
--
-- The single most useful thing here is `<leader>gg` (:Git). That status window
-- has its own built-in keymaps -- see the cheatsheet at the bottom of this file.
return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiffsplit", "Gwrite", "Gread", "Gclog" },

  -- Dotfiles are tracked in a BARE repo (~/.dotfiles.git) whose work tree is
  -- $HOME. Fugitive finds a repo by walking up looking for `.git`, which does
  -- not exist for ~/.zshrc etc -- so without this it silently does nothing on
  -- those files. Setting b:git_dir before fugitive inspects the buffer makes
  -- every <leader>g mapping work on dotfiles too.
  --
  -- Guard: only for files that the dotfiles repo actually TRACKS. Otherwise
  -- every unrelated file under $HOME (downloads, scratch files) would get
  -- wrongly attached to the dotfiles repo.
  init = function()
    local gitdir = vim.env.HOME .. "/.dotfiles.git"
    if vim.fn.isdirectory(gitdir) == 0 then
      return
    end

    vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
      group = vim.api.nvim_create_augroup("DotfilesFugitive", { clear = true }),
      callback = function(args)
        if vim.b[args.buf].git_dir then
          return -- a normal repo already claimed this buffer
        end

        local file = vim.api.nvim_buf_get_name(args.buf)
        if file == "" or not vim.startswith(file, vim.env.HOME) then
          return
        end

        -- Skip if the file sits inside a normal git repo of its own.
        if vim.fs.find(".git", { path = vim.fs.dirname(file), upward = true })[1] then
          return
        end

        local rel = file:sub(#vim.env.HOME + 2)
        local tracked = vim.fn.system({
          "git", "--git-dir=" .. gitdir, "--work-tree=" .. vim.env.HOME,
          "ls-files", "--error-unmatch", rel,
        })
        local _ = tracked
        if vim.v.shell_error == 0 then
          vim.b[args.buf].git_dir = gitdir
        end
      end,
    })
  end,
  keys = {
    -- === Hub ===
    { "<leader>gg", "<cmd>Git<CR>", desc = "Git status (hub)" },

    -- === Commit ===
    { "<leader>gc", "<cmd>Git commit<CR>",                  desc = "Commit" },
    { "<leader>gC", "<cmd>Git commit --amend<CR>",          desc = "Commit --amend" },
    { "<leader>ge", "<cmd>Git commit --amend --no-edit<CR>", desc = "Amend (keep message)" },

    -- === Sync ===
    -- gp pushes the current branch. gP is the safe force-push you want after
    -- an amend or a rebase (refuses if the remote moved under you).
    { "<leader>gp", "<cmd>Git push<CR>",                    desc = "Push" },
    { "<leader>gP", "<cmd>Git push --force-with-lease<CR>", desc = "Push --force-with-lease" },
    -- Two pulls, on purpose:
    --   gu = plain `git pull` (merge). The safe default: creates a merge commit
    --        if both sides moved, and any conflicts surface once, all at once.
    --        Bail out with `git merge --abort`.
    --   gU = `git pull --rebase`. Replays YOUR commits on top of the remote for
    --        a linear history with no merge commit, but conflicts arrive one
    --        commit at a time. Bail out with `git rebase --abort`.
    { "<leader>gu", "<cmd>Git pull<CR>",                    desc = "Pull (merge)" },
    { "<leader>gU", "<cmd>Git pull --rebase<CR>",           desc = "Pull --rebase (linear)" },

    -- Deliberately NOT executed: this leaves `:Git merge ` on the command line
    -- so you type the branch name yourself, then press <CR>.
    { "<leader>gM", ":Git merge ",                          desc = "Merge a branch (type name)" },
    { "<leader>gf", "<cmd>Git fetch --all --prune<CR>",     desc = "Fetch all + prune" },

    -- === Inspect ===
    { "<leader>gb", "<cmd>Git blame<CR>",                        desc = "Blame (scroll-synced)" },
    { "<leader>gl", "<cmd>Git log --oneline --graph --all<CR>",  desc = "Log (graph, all branches)" },
    { "<leader>gL", "<cmd>0Gclog<CR>",                           desc = "Log (this file only)" },
    { "<leader>gB", "<cmd>Git branch<CR>",                       desc = "List branches" },

    -- === Switching branches ===
    -- Like gM, these are NOT executed: they leave the command on the cmdline
    -- so you type the branch name (<Tab> completes it), then press <CR>.
    --   go = switch to an existing branch
    --   gN = create a NEW branch and switch to it
    --   gO = jump back to the previous branch (like `cd -`)
    { "<leader>go", ":Git checkout ",                            desc = "Checkout branch (type name)" },
    { "<leader>gN", ":Git checkout -b ",                         desc = "New branch (type name)" },
    { "<leader>gO", "<cmd>Git checkout -<CR>",                   desc = "Checkout previous branch" },

    -- === Stash ===
    -- Git refuses to switch branches if an uncommitted change would be
    -- clobbered. Stash parks your work, switch, then pop it back later.
    { "<leader>gz", "<cmd>Git stash push -u<CR>", desc = "Stash changes (incl. untracked)" },
    { "<leader>gZ", "<cmd>Git stash pop<CR>",     desc = "Stash pop (restore)" },

    -- === Current file ===
    { "<leader>gw", "<cmd>Gwrite<CR>", desc = "Write + stage file (git add)" },
    { "<leader>gr", "<cmd>Gread<CR>",  desc = "Revert file to index (discard edits)" },

    -- === Diff ===
    { "<leader>gd", "<cmd>Gdiffsplit<CR>",       desc = "Diff vs index (split)" },
    { "<leader>gD", "<cmd>Gdiffsplit HEAD~1<CR>", desc = "Diff vs previous commit" },

    -- === Merge conflicts ===
    -- `:Gdiffsplit!` on a conflicted file opens 3 panes:
    --     //2 = ours (the branch you are on)   | working copy | //3 = theirs
    -- Put the cursor in the middle (working) pane and pull a chunk from
    -- either side with g2 / g3. Then gq to save and close the panes.
    --
    -- To keep BOTH sides: don't use g2/g3 at all. Just edit the working copy
    -- and delete the three marker lines (<<<<<<<, =======, >>>>>>>) with `dd`,
    -- leaving both bodies in whatever order you want.
    --
    -- Vim's built-in `]n` / `[n` jump between conflict markers -- no mapping needed.
    { "<leader>gm", "<cmd>Gdiffsplit!<CR>",  desc = "Merge: 3-way diff on conflict" },
    { "<leader>g2", "<cmd>diffget //2<CR>",  desc = "Merge: take OURS (this chunk)" },
    { "<leader>g3", "<cmd>diffget //3<CR>",  desc = "Merge: take THEIRS (this chunk)" },
    { "<leader>gq", "<cmd>Gwrite<CR><cmd>only<CR>", desc = "Merge: accept + close panes" },
  },
}

-- ============================================================================
-- CHEATSHEET: keys that already work INSIDE the `:Git` status window
-- (built into fugitive, nothing to configure)
--
--   Staging          s      stage file under cursor
--                    u      unstage file under cursor
--                    -      toggle stage/unstage
--                    X      discard change (DESTRUCTIVE)
--                    a      cycle inline/expanded view
--
--   Viewing          =      expand inline diff for this file
--                    >  <   expand / collapse diff
--                    <CR>   open the file
--                    O      open in a new tab
--                    dv ds  diff in vsplit / split
--                    dq     close all diff windows
--
--   Committing       cc     commit
--                    ca     commit --amend
--                    ce     commit --amend --no-edit
--                    cw     reword last commit
--                    crc    revert a commit
--
--   Stash            czz    stash push
--                    czp    stash pop
--
--   Navigation       gu gU  jump to unstaged / untracked section
--                    gi     jump to staged section
--                    gI     edit .gitignore
--                    ]] [[  next / prev section
--                    r  R   reload status
--
--   In `:Git blame`  <CR>   open the commit under cursor
--                    o      open commit in a split
--                    q      close the blame pane
-- ============================================================================
