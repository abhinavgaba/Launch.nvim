local M = {
  "esmuellert/codediff.nvim",
  cmd = "CodeDiff",
}

function M.config()
  local keymap = vim.keymap.set
  keymap("n", "<leader>gCo", "<cmd>CodeDiff HEAD<CR>", { desc = "Open (against HEAD)" })
  keymap("n", "<leader>gCO", "<cmd>CodeDiff<CR>", { desc = "Open (staged/unstaged)" })
  keymap("n", "<leader>gCh", "<cmd>CodeDiff history<CR>", { desc = "History" })
end

return M
