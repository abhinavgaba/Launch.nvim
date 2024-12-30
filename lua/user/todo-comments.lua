-- Colored TODO/FIXME etc labels
local M = {
  "folke/todo-comments.nvim",
  lazy = true,
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {},
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
  }
}

return M
