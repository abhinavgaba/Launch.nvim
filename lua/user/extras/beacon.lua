local M = {
  "rainbowhxch/beacon.nvim",
  event = "VeryLazy",
}

function M.config()
  require("beacon").setup {
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

  local keymap = vim.keymap

  keymap.set("n", "<leader>hc", "<cmd>Beacon<CR>", { desc = "Highlight Current Cursor Position (w/ Beacon)" })
end

return M
