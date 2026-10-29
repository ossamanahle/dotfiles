-- Repo-level git (status, commit, push, merge). Hunk-level work lives in gitsigns.
return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gwrite", "Gread", "Gclog", "Gedit", "Gtabedit" },
  keys = {
    { "<leader>gg", "<cmd>Git<CR>", desc = "Git status (hub)" },

    -- Commit
    { "<leader>gc", "<cmd>Git commit<CR>",                  desc = "Commit" },
    { "<leader>gC", "<cmd>Git commit --amend<CR>",          desc = "Commit --amend" },
    { "<leader>ge", "<cmd>Git commit --amend --no-edit<CR>", desc = "Amend (keep message)" },

    -- Sync (gu = merge pull, gU = rebase pull)
    { "<leader>gp", "<cmd>Git push<CR>",                    desc = "Push" },
    { "<leader>gP", "<cmd>Git push --force-with-lease<CR>", desc = "Push --force-with-lease" },
    { "<leader>gu", "<cmd>Git pull<CR>",                    desc = "Pull (merge)" },
    { "<leader>gU", "<cmd>Git pull --rebase<CR>",           desc = "Pull --rebase (linear)" },
    -- Not executed: leaves the command line open for a branch name
    { "<leader>gM", ":Git merge ",                          desc = "Merge a branch (type name)" },
    { "<leader>gf", "<cmd>Git fetch --all --prune<CR>",     desc = "Fetch all + prune" },

    -- Inspect
    { "<leader>gb", "<cmd>Git blame<CR>",                        desc = "Blame (scroll-synced)" },
    { "<leader>gl", "<cmd>Git log --oneline --graph --all<CR>",  desc = "Log (graph, all branches)" },
    { "<leader>gL", "<cmd>0Gclog<CR>",                           desc = "Log (this file only)" },
    { "<leader>gB", "<cmd>Git branch<CR>",                       desc = "List branches" },

    -- Branches (go/gN wait for a branch name)
    { "<leader>go", ":Git checkout ",                            desc = "Checkout branch (type name)" },
    { "<leader>gN", ":Git checkout -b ",                         desc = "New branch (type name)" },
    { "<leader>gO", "<cmd>Git checkout -<CR>",                   desc = "Checkout previous branch" },

    -- Stash
    { "<leader>gz", "<cmd>Git stash push -u<CR>", desc = "Stash changes (incl. untracked)" },
    { "<leader>gZ", "<cmd>Git stash pop<CR>",     desc = "Stash pop (restore)" },

    -- Current file
    { "<leader>gw", "<cmd>Gwrite<CR>", desc = "Write + stage file (git add)" },
    { "<leader>gr", "<cmd>Gread<CR>",  desc = "Revert file to index (discard edits)" },

    -- Diff
    { "<leader>gd", "<cmd>Gdiffsplit<CR>",       desc = "Diff vs index (split)" },
    { "<leader>gD", "<cmd>Gdiffsplit HEAD~1<CR>", desc = "Diff vs previous commit" },

    -- Merge conflicts: 3 panes = ours (//2) | working | theirs (//3).
    -- In the middle pane take a side with g2/g3, then gq. ]n / [n jump between markers.
    { "<leader>gm", "<cmd>Gdiffsplit!<CR>",  desc = "Merge: 3-way diff on conflict" },
    { "<leader>g2", "<cmd>diffget //2<CR>",  desc = "Merge: take OURS (this chunk)" },
    { "<leader>g3", "<cmd>diffget //3<CR>",  desc = "Merge: take THEIRS (this chunk)" },
    { "<leader>gq", "<cmd>Gwrite<CR><cmd>only<CR>", desc = "Merge: accept + close panes" },
  },
}

-- Inside the :Git window:
--   s/u/-  stage/unstage/toggle   X  discard   =  inline diff   <CR>  open
--   cc/ca/ce  commit/amend/amend no-edit   czz/czp  stash push/pop
--   ]] [[  next/prev section   gI  edit .gitignore   R  reload
