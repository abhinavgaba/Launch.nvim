local M = {
  "mbbill/undotree",
  event = "VeryLazy",
}

function M.config()
  vim.keymap.set("n", "<leader>u", "<cmd>UndotreeToggle<cr>", { desc = "Undo-tree Toggle" })
end

return M
