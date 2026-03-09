local M = {
  "folke/sidekick.nvim",
  event = "VeryLazy",
  init = function()
    vim.lsp.enable("copilot_ls")
  end,
  opts = {},
  keys = {
    {
      "<tab>",
      function()
        if not require("sidekick").nes_jump_or_apply() then
          return "<Tab>"
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
  },
}

return M
