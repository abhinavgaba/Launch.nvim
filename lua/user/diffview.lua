local M = {
  "sindrets/diffview.nvim",
  event = "BufEnter",
}

vim.api.nvim_create_user_command("DiffviewShowCommit", function(input)
  local args = input.fargs
  -- Change first arg from COMMIT to COMMIT^..COMMIT
  local commit_id = table.remove(args, 1)
  local commit_id_vs_previous_string = commit_id .. "^" .. ".." .. commit_id

  local cmd_string = "DiffviewOpen " .. commit_id_vs_previous_string .. " " .. table.concat(args, "", 2)

  vim.api.nvim_command(cmd_string)
  -- vim.api.nvim_cmd({cmd = 'DiffviewOpen'}, args)
end, { nargs = "+" })

-- Get the text under visual selection
-- local function get_visual_selection(line1, line2)
--   local s_start = vim.fn.getpos "'<"
--   local s_end = vim.fn.getpos "'>"
--   local n_lines = math.abs(s_end[2] - s_start[2]) + 1
--   local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
--   lines[1] = string.sub(lines[1], s_start[3], -1)
--   if n_lines == 1 then
--     lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
--   else
--     lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
--   end
--   return table.concat(lines, "\n")
-- end

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

vim.api.nvim_create_user_command("DiffviewShowSelectedCommit", function(input)
  if input.line1 ~= input.line2 then
    error "Input selection should not span multiple lines"
  end

  local commit_id = get_visual_selection_oneline(input.line1)
  local commit_id_vs_previous_string = commit_id .. "^" .. ".." .. commit_id

  local cmd_string = "DiffviewOpen " .. " " .. commit_id_vs_previous_string
  vim.api.nvim_command(cmd_string)

end, { nargs = 0, range = true })

function M.config()
  local keymap = vim.keymap.set
  keymap("n", "<leader>go", "<cmd>DiffviewOpen -uno<CR>", { desc = "Git Diff View Open (against HEAD)" })
  keymap("n", "<leader>ga", "<cmd>DiffviewOpen<CR>", { desc = "Git Diff View Open (including Untracked files)" })
  keymap("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Git Diff View Close" })
  keymap("n", "<leader>gf", "<cmd>DiffviewFileHistory<CR>", { desc = "Git Diff File History (All Files)" })
  keymap("v", "<leader>gf", "<cmd>DiffviewFileHistory<CR>", { desc = "Git Diff File History (Selected Lines)" })
  keymap("v", "<leader>gs", "<cmd>DiffviewShowSelectedCommit<CR>", { desc = "Git Diff Show Commit" })
end
return M
