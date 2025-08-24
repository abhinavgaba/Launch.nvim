-- mini-surround config based on LazyVim
local M = {
  "echasnovski/mini.surround",
  event = "VeryLazy",
}

M.opts = {
  mappings = {
    add = "gsa", -- Add surrounding in Normal and Visual modes
    delete = "gsd", -- Delete surrounding
    find = "gsf", -- Find surrounding (to the right)
    find_left = "gsF", -- Find surrounding (to the left)
    highlight = "gsh", -- Highlight surrounding
    replace = "gsr", -- Replace surrounding
    update_n_lines = "gsn", -- Update `n_lines`
  },
}

return M
