local M = {
  "mbbill/undotree",
  event = "VeryLazy",
}

function M.config()
  vim.keymap.set("n", "<leader>tu", "<cmd>UndotreeToggle<cr>", { desc = "Undo-tree Toggle" })
end
return M
