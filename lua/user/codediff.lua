local M = {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
  build = ":CodeDiff install",
  keys = {
    { "<leader>gco", "<cmd>CodeDiff HEAD<CR>", desc = "Open (against HEAD)" },
    { "<leader>gcO", "<cmd>CodeDiff<CR>", desc = "Open (staged/unstaged)" },
    { "<leader>gch", "<cmd>CodeDiff history<CR>", desc = "History" },
    { "<leader>gcv", ":CodeDiffViewCommit<CR>", mode = { "n", "v" }, desc = "View Commit" },
  },
}

-- Get the text from visual selection, assuming that the selection only spans
-- a single line.
local function get_visual_selection_oneline(linenr)
  local s_start = vim.fn.getpos "'<"
  local s_end = vim.fn.getpos "'>"

  local lines = vim.api.nvim_buf_get_lines(0, linenr - 1, linenr, false)

  lines[1] = string.sub(lines[1], s_start[3], -1)
  lines[1] = string.sub(lines[1], 1, s_end[3] - s_start[3] + 1)

  return lines[1]
end

-- Show the commit under cursor/selection/passed-as argument, in CodeDiff.
vim.api.nvim_create_user_command("CodeDiffViewCommit", function(input)
  local commit_id

  -- Get commit ID from visual selection, cursor, or argument
  if input.range ~= 0 then
    if input.line1 ~= input.line2 then
      error "Input selection should not span multiple lines"
    end
    commit_id = get_visual_selection_oneline(input.line1)
  elseif #input.fargs == 0 then
    commit_id = vim.fn.expand "<cword>"
  else
    commit_id = input.fargs[1]
  end

  -- Show the commit vs its parent
  local cmd_string = "CodeDiff " .. commit_id .. "^ " .. commit_id
  vim.api.nvim_command(cmd_string)
end, { nargs = "?", range = true })

-- Show commit info in a floating window
local function show_commit_info()
  local session = require("codediff.ui.lifecycle.session").get_active_diffs()[vim.api.nvim_get_current_tabpage()]
  if not session then
    vim.notify("Not in a CodeDiff session", vim.log.levels.WARN)
    return
  end

  local commit = session.original_revision or session.modified_revision
  if not commit or commit == "WORKING" or commit == "STAGED" then
    vim.notify("No commit to show info for", vim.log.levels.WARN)
    return
  end

  local git_root = session.git_root
  if not git_root then
    vim.notify("No git root found", vim.log.levels.WARN)
    return
  end

  -- Run git show asynchronously
  vim.system(
    { "git", "-C", git_root, "show", "--stat", "--format=fuller", commit },
    { text = true },
    vim.schedule_wrap(function(result)
      if result.code ~= 0 then
        vim.notify("Failed to get commit info: " .. (result.stderr or ""), vim.log.levels.ERROR)
        return
      end

      local lines = vim.split(result.stdout, "\n")

      -- Create floating window
      local buf = vim.api.nvim_create_buf(false, true)
      vim.bo[buf].bufhidden = "wipe"
      vim.bo[buf].filetype = "git"
      vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
      vim.bo[buf].modifiable = false

      -- Calculate window size
      local width = math.min(100, vim.o.columns - 10)
      local height = math.min(#lines + 2, vim.o.lines - 10)

      local opts = {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " Commit Info ",
        title_pos = "center",
      }

      local win = vim.api.nvim_open_win(buf, true, opts)
      vim.wo[win].wrap = false
      vim.wo[win].cursorline = true

      -- Close on q or Esc
      vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true })
      vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, nowait = true })
    end)
  )
end

-- Setup autocmds at module load time (before lazy-loading)
local group = vim.api.nvim_create_augroup("CodeDiffCustom", { clear = true })

-- Helper to set keymap on a buffer
local function set_commit_info_keymap(bufnr)
  if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  vim.keymap.set("n", "gi", show_commit_info, { buffer = bufnr, desc = "Show commit info" })
end

-- Hook into CodeDiff's open event
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "CodeDiffOpen",
  callback = function()
    local tabpage = vim.api.nvim_get_current_tabpage()
    local ok, session_mod = pcall(require, "codediff.ui.lifecycle.session")
    if not ok then
      return
    end
    local session = session_mod.get_active_diffs()[tabpage]
    if session then
      set_commit_info_keymap(session.original_bufnr)
      set_commit_info_keymap(session.modified_bufnr)
    end
  end,
})

-- Also handle BufEnter to catch when switching between buffers in CodeDiff
vim.api.nvim_create_autocmd("BufEnter", {
  group = group,
  callback = function(args)
    local tabpage = vim.api.nvim_get_current_tabpage()
    local ok, session_mod = pcall(require, "codediff.ui.lifecycle.session")
    if not ok then
      return
    end
    local session = session_mod.get_active_diffs()[tabpage]
    if session then
      set_commit_info_keymap(args.buf)
    end
  end,
})

return M
