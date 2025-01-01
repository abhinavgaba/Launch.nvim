local M = {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  dependencies = {
    { "nvim-lua/plenary.nvim" },
  },
  keys = function()
    return {
      {"<s-m>", function() require('user.harpoon').mark_file() end, desc = "Harpoon" },
      {"<leader>h", function() require('harpoon.ui').toggle_quick_menu() end, desc = "Harpoon" },
    }
  end
}

function M.mark_file()
  require("harpoon.mark").add_file()
  vim.notify "󱡅  marked file"
end

return M
