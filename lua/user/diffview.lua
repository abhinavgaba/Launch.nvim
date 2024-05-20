local M = {
  "sindrets/diffview.nvim",
  event = "BufEnter",
}

vim.api.nvim_create_user_command("DiffviewShowCustom", function(input)
  local args = input.fargs
  -- Change first arg from COMMIT to COMMIT^..COMMIT
  local commit_id = table.remove(args, 1)
  local commit_id_vs_previous_string = commit_id .. "^" .. ".." .. commit_id
  table.insert(args, 1, commit_id_vs_previous_string)

  local cmd_string = "DiffviewOpen " .. commit_id_vs_previous_string .. " " .. table.concat(args, "", 2)
  print(cmd_string)

  vim.api.nvim_command(cmd_string)
  -- vim.api.nvim_cmd({cmd = 'DiffviewOpen'}, args)
end, { nargs = "*" })

function M.config()
  local keymap = vim.keymap.set
  keymap("n", "<leader>go", "<cmd>DiffviewOpen<CR>", { desc = "Git Diff View Open (against HEAD)" })
  keymap("n", "<leader>gq", "<cmd>DiffviewClose<CR>", { desc = "Git Diff View Close" })
  keymap("n", "<leader>gf", "<cmd>DiffviewFileHistory<CR>", { desc = "Git Diff File History" })
end
return M
