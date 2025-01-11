--- @type LazyPluginSpec
local M = {
  "Wansmer/treesj",
  dependencies = { "nvim-treesitter/nvim-treesitter" }, -- if you install parsers with `nvim-treesitter`
  opts = { use_default_keymaps = false, max_join_length = 150 },
  keys = {
    { "<leader>cj", function() require("treesj").toggle() end, desc = "SplitJoin Toggle" },
  },
}

return M
