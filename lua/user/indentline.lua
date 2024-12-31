local M = {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  --  event = "VeryLazy", -- Lazy-loading doesn't work with rainbow-delimiters.
  dependencies = {
    "HiPhish/rainbow-delimiters.nvim",
    "folke/snacks.nvim",
  },
}
local scope_highlight = {
  "RainbowRed",
  "RainbowYellow",
  "RainbowBlue",
  "RainbowOrange",
  "RainbowGreen",
  "RainbowViolet",
  "RainbowCyan",
}

local indent_highlight = {
  "Whitespace",
}

function M.opts()
  local icons = require "user.icons"
  Snacks.toggle({
    name = "Indention Guides",
    get = function()
      return require("ibl.config").get_config(0).enabled
    end,
    set = function(state)
      require("ibl").setup_buffer(0, { enabled = state })
    end,
  }):map "<leader>tg"

  return {
    scope = { highlight = scope_highlight, char = icons.ui.BoldLineMiddle },
    indent = { highlight = indent_highlight, char = icons.ui.LineMiddleDashedCompact },
    -- scope = { enabled = false },
    exclude = {
      filetypes = {
        "help",
        "startify",
        "dashboard",
        "lazy",
        "text",
        "mason",
        "harpoon",
        "DressingInput",
        "NeogitCommitMessage",
        "qf",
        "dirvish",
        "oil",
        "minifiles",
        "fugitive",
        "alpha",
        "NvimTree",
        "lazy",
        "NeogitStatus",
        "Trouble",
        "netrw",
        "lir",
        "DiffviewFiles",
        "Outline",
        "Jaq",
        "spectre_panel",
        "toggleterm",
        "DressingSelect",
        "TelescopePrompt",
      },
    },
  }
end

function M.config(_, opts)
  local hooks = require "ibl.hooks"

  -- create the highlight groups in the highlight setup hook, so they are reset
  -- every time the colorscheme changes
  hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
  end)

  vim.g.rainbow_delimiters = { highlight = scope_highlight }

  hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
  require("ibl").setup(opts)
end

return M
