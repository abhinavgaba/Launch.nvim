local M = {
  "tpope/vim-abolish",
  event = "VeryLazy",
  init = function()
    vim.g.abolish_no_mappings = true
  end,
}

return M
