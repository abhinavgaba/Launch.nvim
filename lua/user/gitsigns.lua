local M = {
  "lewis6991/gitsigns.nvim",
  event = "BufEnter",
  cmd = "Gitsigns",
}

-- Look at all the open windows open in the current tab, and close any
-- associated with GitSigns (i.e. its buffer name starts with 'gitsigns:').
local function closeGitsignsWindows()
  local windows = vim.api.nvim_tabpage_list_wins(0)

  for _, winnr in pairs(windows) do
    local bufnr = vim.api.nvim_win_get_buf(winnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)

    if string.find(bufname, "^gitsigns:") then
      vim.api.nvim_win_close(winnr, true)
    end
  end
end

local function gitSignsDiffVsCommit(commit_id)
  if commit_id == "" or commit_id == "^" then
    error "No commit under the cursor to diff against."
  end

  -- If the current buffer is for Git blame or Diffview, then close it before we
  -- start a diff against the commit
  if vim.bo.filetype == "blame" and vim.fn.exists "BlameToggle" then
    print "Toggling Blame"
    vim.api.nvim_command "BlameToggle"
  end

  if string.find(vim.bo.filetype, "^Diffview") and vim.fn.exists "DiffviewClose" then
    print "Turn off Diffview"
    vim.api.nvim_command "DiffviewClose"
  end

  -- It's possible that the current window is for a preview-popup created by
  -- Gitsigns blame_line, in which case we should close it as we cannot start
  -- a diff from it. This might also help with other similar pop-ups.
  if vim.api.nvim_buf_get_name(0) == "" then
    vim.api.nvim_win_close(0, true)
  end

  require("gitsigns").diffthis(commit_id)
end

-- Run "GitSigns diffthis <commit-id>", where commit-id is the curent word
-- under the cursor.
local function gitSignsDiffVsCword()
  local commit_id = vim.fn.expand "<cword>"
  gitSignsDiffVsCommit(commit_id)
end

-- Run "GitSigns diffthis <commit-id>", where commit-id is the parent of
-- the commit representing the current word under the cursor.
local function gitSignsDiffVsCwordParent()
  local commit_id = vim.fn.expand "<cword>"
  gitSignsDiffVsCommit(commit_id .. "^")
end

M.config = function()
  local icons = require "user.icons"

  local wk = require "which-key"
  wk.register {
    ["<leader>gj"] = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
    ["]h"] = { "<cmd>lua require 'gitsigns'.next_hunk({navigation_message = false})<cr>", "Next Hunk" },
    ["<leader>gk"] = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
    ["[h"] = { "<cmd>lua require 'gitsigns'.prev_hunk({navigation_message = false})<cr>", "Prev Hunk" },
    ["<leader>gp"] = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
    ["<leader>gr"] = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
    ["<leader>gl"] = { "<cmd>lua require 'gitsigns'.blame_line()<cr>", "Blame" },
    ["<leader>gh"] = { "<cmd>lua require 'gitsigns'.toggle_linehl()<cr>", "Toggle Highlighting of Modified Lines" },
    ["<leader>gR"] = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
    ["<leader>gs"] = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
    ["<leader>gu"] = {
      "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
      "Undo Stage Hunk",
    },
    ["<leader>gdh"] = { "<cmd>Gitsigns diffthis HEAD<cr>", "Diff vs HEAD" },
    ["<leader>gdc"] = { gitSignsDiffVsCword, "Diff vs Commit-under-Cursor" },
    ["<leader>gdp"] = { gitSignsDiffVsCword, "Diff vs Commit-under-Cursor's Parent" },
    ["<leader>gD"] = { closeGitsignsWindows, "Diff Close" },
  }

  require("gitsigns").setup {
    signs = {
      add = {
        hl = "GitSignsAdd",
        text = icons.ui.BoldLineMiddle,
        numhl = "GitSignsAddNr",
        linehl = "GitSignsAddLn",
      },
      change = {
        hl = "GitSignsChange",
        text = icons.ui.BoldLineDashedMiddle,
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
      delete = {
        hl = "GitSignsDelete",
        text = icons.ui.TriangleShortArrowRight,
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      topdelete = {
        hl = "GitSignsDelete",
        text = icons.ui.TriangleShortArrowRight,
        numhl = "GitSignsDeleteNr",
        linehl = "GitSignsDeleteLn",
      },
      changedelete = {
        hl = "GitSignsChange",
        text = icons.ui.BoldLineMiddle,
        numhl = "GitSignsChangeNr",
        linehl = "GitSignsChangeLn",
      },
    },
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    linehl = true,
    attach_to_untracked = true,
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    update_debounce = 200,
    max_file_length = 40000,
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
  }
end

return M
