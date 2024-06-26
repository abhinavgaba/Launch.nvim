local M = {
  "sindrets/diffview.nvim",
  event = "VeryLazy",
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
}

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

-- Show the commit under cursor/selection/passed-as argument, in Diffview.
vim.api.nvim_create_user_command("DiffviewViewCommit", function(input)
  local args = input.fargs
  local cmd_string

  -- vim.print(vim.inspect(input.fargs), vim.inspect(input.line1), vim.inspect(input.line2), vim.inspect(input.range))

  -- Change first arg from COMMIT to COMMIT^..COMMIT
  if input.range ~= 0 then
    if input.line1 ~= input.line2 then
      error "Input selection should not span multiple lines"
    end
    local commit_id = get_visual_selection_oneline(input.line1)
    local commit_id_vs_previous_string = commit_id .. "^" .. ".." .. commit_id
    cmd_string = "DiffviewOpen " .. " " .. commit_id_vs_previous_string
  elseif #input.fargs == 0 then
    local commit_id = vim.fn.expand "<cword>"
    local commit_id_vs_previous_string = commit_id .. "^" .. ".." .. commit_id
    cmd_string = "DiffviewOpen " .. " " .. commit_id_vs_previous_string
  else
    local commit_id = table.remove(args, 1)
    local commit_id_vs_previous_string = commit_id .. "^" .. ".." .. commit_id
    cmd_string = "DiffviewOpen " .. commit_id_vs_previous_string .. " " .. table.concat(args, "", 2)
  end

  vim.api.nvim_command(cmd_string)
  -- vim.api.nvim_cmd({cmd = 'DiffviewOpen'}, args)
end, { nargs = "*", range = true })

function M.config()
  local keymap = vim.keymap.set
  keymap("n", "<leader>go", "<cmd>DiffviewOpen -uno<CR>", { desc = "Diff View (DV) Open (against HEAD)" })
  keymap("n", "<leader>gO", "<cmd>DiffviewOpen<CR>", { desc = "Diff View (DV) Open (Including Untracked)" })
  keymap("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Diff View (DV) Close" })
  keymap("n", "<leader>gf", "<cmd>DiffviewFileHistory --follow --no-merges --show-pulls %<CR>", {desc = "DV File History"})
  keymap("n", "<leader>gF", "<cmd>DiffviewFileHistory<CR>", { desc = "DV File History (All Files)" })
  keymap("v", "<leader>gf", ":DiffviewFileHistory<CR>", { desc = "DV File History (Selected Lines)" })
  keymap({ "n", "v"}, "<leader>gv", ":DiffviewViewCommit<CR>", { desc = "DV View Commit" })
end
return M
