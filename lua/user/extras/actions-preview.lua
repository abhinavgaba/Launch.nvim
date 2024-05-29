local M = {
  "aznhe21/actions-preview.nvim",
  event = "VeryLazy",
}

function M.config()
  require("actions-preview").setup()
  vim.keymap.set({ "v", "n" }, "<leader>la", require("actions-preview").code_actions, {desc="Code Actions (w/ Preview)"})
end

return M
