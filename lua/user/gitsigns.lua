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

local function set_keymaps(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
      opts = opts or {}
      opts.buffer = bufnr
      vim.keymap.set(mode, l, r, opts)
    end

    -- Actions
    map('n', "<leader>gD", closeGitsignsWindows, {desc = "Diff Close"})
    map('n', "<leader>gdq", closeGitsignsWindows, {desc = "Diff Close"})
    map('n', "<leader>gR", gitsigns.reset_buffer, {desc = "Reset Buffer"})
    map('n', "<leader>gdc", gitSignsDiffVsCword, {desc = "Diff vs Commit-under-Cursor"})
    map('n', "<leader>gdp", gitSignsDiffVsCwordParent, {desc = "Diff vs Commit-under-Cursor's Parent"})
    map('n', "<leader>gdh", function() gitsigns.diffthis('HEAD') end, {desc = "Diff vs HEAD"})
    map('n', "<leader>gdH", function() gitsigns.diffthis('HEAD^') end, {desc = "Diff vs HEAD's parent"})
    map('n', "<leader>gds", gitsigns.diffthis, {desc = "Diff vs Staged"})
    map('n', "<leader>gh", gitsigns.toggle_linehl, {desc = "Toggle Highlighting of Modified Lines"})
    map('n', "<leader>gk", function() gitsigns.nav_hunk('prev', {navigation_message = false}) end, {desc = "Prev Hunk"})
    map('n', "<leader>gK", function() gitsigns.nav_hunk('first', {navigation_message = false}) end, {desc = "First Hunk"})
    map('n', "<leader>gj", function() gitsigns.nav_hunk('next', {navigation_message = false}) end, {desc = "Next Hunk"})
    map('n', "<leader>gJ", function() gitsigns.nav_hunk('last', {navigation_message = false}) end, {desc = "Last Hunk"})
    map('n', "<leader>gl", gitsigns.blame_line, {desc = "Blame"})
    map('n', "<leader>gp", gitsigns.preview_hunk, {desc = "Preview Hunk"})
    map('n', "<leader>gs", gitsigns.stage_hunk, {desc = "Stage Hunk"})
    map('n', '<leader>gS', gitsigns.stage_buffer, {desc = "Stage Buffer"})
    map('n', "<leader>gr", gitsigns.reset_hunk, {desc = "Reset Hunk"})
    map('v', '<leader>gs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = "Stage Hunk"})
    map('v', '<leader>gr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, {desc = "Reset Hunk"})
    map('n', "<leader>gu", gitsigns.undo_stage_hunk, {desc = "Undo Stage Hunk"})
    map('n', '<leader>gt', gitsigns.toggle_deleted, {desc = "Gitsigns Toggle deleted"})

    map('n', "[h", function() gitsigns.nav_hunk('prev', {navigation_message = false}) end, {desc = "Prev Hunk"})
    map('n', "[H", function() gitsigns.nav_hunk('first', {navigation_message = false}) end, {desc = "First Hunk"})
    map('n', "]h", function() gitsigns.nav_hunk('next', {navigation_message = false}) end, {desc = "Next Hunk"})
    map('n', "]H", function() gitsigns.nav_hunk('last', {navigation_message = false}) end, {desc = "Last Hunk"})

    -- Text object
    map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
end

M.opts = {
  signs = {
    add = {
      text = require("user.icons").ui.BoldLineMiddle,
    },
    change = {
      text = require("user.icons").ui.BoldLineDashedMiddle,
    },
    delete = {
      text = require("user.icons").ui.TriangleShortArrowRight,
    },
    topdelete = {
      text = require("user.icons").ui.TriangleShortArrowRight,
    },
    changedelete = {
      text = require("user.icons").ui.BoldLineMiddle,
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
  on_attach = set_keymaps,
}

return M
