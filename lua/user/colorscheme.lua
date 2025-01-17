local M = {
  --"folke/tokyonight.nvim",
  --  "LunarVim/darkplus.nvim",
  -- Similar to jellybeans
  -- 'cryptomilk/nightcity.nvim',
  -- Nice colors, but no syntax when highlighted
  -- 'mhartington/oceanic-next',
  -- Greenish, but quite like jellybeans. Pop-up menu for autocomplete
  -- doesn't show highlights very well. But has args vs non-args as bold/non-bold.
  -- "savq/melange-nvim",
  "catppuccin/nvim",
  -- Fairly  close to jellybeanhs but doesn't work well with treesitter-context
  -- "rebelot/kanagawa.nvim",
  -- Bluish alternative to jellybeans
  -- 'lourenci/github-colors',
  -- "bluz71/vim-nightfly-colors",
  -- "EdenEast/nightfox.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
}

function M.config()
  -- vim.cmd.colorscheme "carbonfox"
  -- vim.cmd.colorscheme "nightfly"
  -- vim.cmd.colorscheme "nightcity-afterlife"
  -- vim.g.oceanic_next_terminal_bold = 1
  -- vim.g.oceanic_next_terminal_italic = 1
  -- vim.cmd.colorscheme "OceanicNext"
  require("catppuccin").setup {
    dim_inactive = {
      enabled = true, -- dims the background color of inactive window
    },
    integrations = { blink_cmp = true },
  }

  vim.cmd.colorscheme "catppuccin"
  -- vim.cmd.colorscheme "github-colors"
end

-- Setup for tokyonight
-- function M.config()
--   local transparent = false -- set to true if you would like to enable transparency
--
--   local bg = "#011628"
--   local bg_dark = "#011423"
--   local bg_highlight = "#143652"
--   local bg_search = "#0A64AC"
--   local bg_visual = "#275378"
--   local fg = "#CBE0F0"
--   local fg_dark = "#B4D0E9"
--   local fg_gutter = "#627E97"
--   local border = "#547998"
--
--   require("tokyonight").setup {
--     style = "night",
--     transparent = transparent,
--     styles = {
--       sidebars = transparent and "transparent" or "dark",
--       floats = transparent and "transparent" or "dark",
--     },
--     on_colors = function(colors)
--       colors.bg = bg
--       colors.bg_dark = transparent and colors.none or bg_dark
--       colors.bg_float = transparent and colors.none or bg_dark
--       colors.bg_highlight = bg_highlight
--       colors.bg_popup = bg_dark
--       colors.bg_search = bg_search
--       colors.bg_sidebar = transparent and colors.none or bg_dark
--       colors.bg_statusline = transparent and colors.none or bg_dark
--       colors.bg_visual = bg_visual
--       colors.border = border
--       colors.fg = fg
--       colors.fg_dark = fg_dark
--       colors.fg_float = fg
--       colors.fg_gutter = fg_gutter
--       colors.fg_sidebar = fg_dark
--     end,
--   }
--
--   vim.cmd.colorscheme "tokyonight"
-- end

return M
