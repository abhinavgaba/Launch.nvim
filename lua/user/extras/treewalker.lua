-- walk/move treesitter objects
--- @type LazyPluginSpec
local M = {
  "aaronik/treewalker.nvim",
  event = "VeryLazy",
}

local function set_keymaps()
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function()
      local parsers = require("nvim-treesitter.parsers")
      if parsers.has_parser() then
        -- movement
        vim.keymap.set({ "n", "v" }, "<A-k>", "<cmd>Treewalker Up<cr>", { silent = true, desc = "Treesitter Walk Up"})
        vim.keymap.set({ "n", "v" }, "<A-j>", "<cmd>Treewalker Down<cr>", { silent = true, desc = "Treesitter Walk Down" })
        vim.keymap.set({ "n", "v" }, "<A-l>", "<cmd>Treewalker Right<cr>", { silent = true, desc = "Treesitter Walk Right" })
        vim.keymap.set({ "n", "v" }, "<A-h>", "<cmd>Treewalker Left<cr>", { silent = true, desc = "Treesitter Walk Left" })

        -- swapping
        vim.keymap.set("n", "<A-S-j>", "<cmd>Treewalker SwapDown<cr>", { silent = true, desc = "Treesitter Swap Down" })
        vim.keymap.set("n", "<A-S-k>", "<cmd>Treewalker SwapUp<cr>", { silent = true, desc = "Treesitter Swap Up" })
        vim.keymap.set("n", "<A-S-l>", "<cmd>Treewalker SwapRight<CR>", { silent = true, desc = "Treesitter Swap Right" })
        vim.keymap.set("n", "<A-S-h>", "<cmd>Treewalker SwapLeft<CR>", { silent = true, desc = "Treesitter Swap Left" })
      end
    end,
  })
end

function M.init()
  set_keymaps()
end

return M
