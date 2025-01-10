local M = {
  "MeanderingProgrammer/render-markdown.nvim",
  -- dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.nvim" }, -- if you use the mini.nvim suite
  dependencies = { "nvim-treesitter/nvim-treesitter", "echasnovski/mini.icons" }, -- if you use standalone mini plugins
  -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
  ---@module 'render-markdown'
  ---@type render.md.UserConfig
  opts = {
    file_types = { "markdown" },
  },
  ft = { "markdown" },
  -- allows extending file_types elsewhere in your config
  -- without having to redefine it
  opts_extend = { "file_types" },
}

function M.config(_, opts)
  require("render-markdown").setup(opts)

  Snacks.toggle({
    name = "Render Markdown",
    get = function()
      return require("render-markdown.state").enabled
    end,
    set = function(enabled)
      local m = require "render-markdown"
      if enabled then
        m.enable()
      else
        m.disable()
      end
    end,
  }):map "<leader>um"
end

return M
