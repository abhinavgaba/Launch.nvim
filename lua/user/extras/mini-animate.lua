local M = {
  "echasnovski/mini.animate",
  event = "VeryLazy",
  cond = vim.g.neovide == nil,
  opts = {
    cursor = { enable = false },
    scroll = { enable = false },
  },
}

local set_toggle_keymap = function()
  local lazy_utils = require "user.lazy-utils"
  local has_snacks = lazy_utils.has "snacks.nvim"
  if not has_snacks then
    return
  end

  lazy_utils.on_load("snacks.nvim", function()
    Snacks.toggle({
      name = "Mini Animate",
      get = function()
        return not vim.g.minianimate_disable
      end,
      set = function(state)
        vim.g.minianimate_disable = not state
      end,
    }):map "<leader>ua"
  end)
end

function M.config(_, opts)
  set_toggle_keymap()

  require("mini.animate").setup(opts)
end

return M
