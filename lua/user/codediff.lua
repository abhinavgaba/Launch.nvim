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

return M
