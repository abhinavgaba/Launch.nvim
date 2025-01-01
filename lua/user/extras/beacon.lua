-- Highlight Current Cursor Position on window change/on-demand etc
local M = {
  "rainbowhxch/beacon.nvim",
  keys = {
    { "<leader>uc", "<cmd>Beacon<CR>", desc = "Highlight Current Cursor Position (w/ Beacon)" },
  },
  cmd = "Beacon"
}

M.opts = {
  enable = true,
  size = 50,
  fade = true,
  minimal_jump = 5,
  show_jumps = true,
  focus_gained = true,
  shrink = true,
  timeout = 3000,
  ignore_buffers = {},
  ignore_filetypes = {},
}

return M
