local M = {
  "aznhe21/actions-preview.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>la", function() require("actions-preview").code_actions() end, desc = "Code Actions (w/ Preview)", mode = { "v", "n" } },
  }
}

return M
