-- Telescope extension to search git commits, files, branches, and more.
--- @type LazyPluginSpec
local M = {
  "aaronhallaert/advanced-git-search.nvim",
  cmd = { "AdvancedGitSearch" },
  dependencies = {
    "ibhagwan/fzf-lua",
    -- "nvim-telescope/telescope.nvim",
    -- to show diff splits and open commits in browser
    "tpope/vim-fugitive",
    -- to open commits in browser with fugitive
    "tpope/vim-rhubarb",
    -- optional: to replace the diff from fugitive with diffview.nvim
    -- (fugitive is still needed to open in browser)
    -- "sindrets/diffview.nvim",
  },
}

M.opts = {
  -- Browse command to open commits in browser. Default fugitive GBrowse.
  -- {commit_hash} is the placeholder for the commit hash.
  browse_command = "GBrowse {commit_hash}",
  -- when {commit_hash} is not provided, the commit will be appended to the specified command seperated by a space
  -- browse_command = "GBrowse",
  -- => both will result in calling `:GBrowse commit`

  -- fugitive or diffview
  diff_plugin = "fugitive",
  -- customize git in previewer
  -- e.g. flags such as { "--no-pager" }, or { "-c", "delta.side-by-side=false" }
  git_flags = {},
  -- customize git diff in previewer
  -- e.g. flags such as { "--raw" }
  git_diff_flags = {},
  git_log_flags = {},
  -- Show builtin git pickers when executing "show_custom_functions" or :AdvancedGitSearch
  show_builtin_git_pickers = false,
  entry_default_author_or_date = "author", -- one of "author" or "date"
  keymaps = {
    -- following keymaps can be overridden
    toggle_date_author = "<C-a>",
    open_commit_in_browser = "<C-o>",
    copy_commit_hash = "<C-y>",
    show_entire_commit = "<C-e>",
  },
}

function M.config(_, opts)
  require("advanced_git_search.fzf").setup(opts)
end

return M
