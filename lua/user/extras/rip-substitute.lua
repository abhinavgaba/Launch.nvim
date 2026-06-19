-- Search & replace in the current buffer, like `:substitute` but with a live
-- preview and modern regex syntax (powered by `ripgrep`).
--- @type LazyPluginSpec
local M = {
  "chrisgrieser/nvim-rip-substitute",
  cmd = "RipSubstitute",
  keys = {
    {
      "<leader>sr",
      function()
        require("rip-substitute").sub()
      end,
      mode = { "n", "x" },
      desc = "Rip Substitute (buffer)",
    },
  },
  ---@module "rip-substitute"
  ---@type ripSubstituteConfig
  opts = {},
}

return M
