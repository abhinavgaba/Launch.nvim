local M = {
  "nanozuki/tabby.nvim",
  event = "VeryLazy",
}

function M.config()
--   -- Use the excellent tabby configuration from nightfox's extras
--   -- https://github.com/UserEast/nightfox.nvim/tree/main/mics/tabby.lua
--
--   local fmt = string.format
--
--   ----------------------------------------------------------------------------------------------------
--   -- Colors
--
--   ---Convert color number to hex string
--   ---@param n number
--   ---@return string
--   local hex = function(n)
--     if n then
--       return fmt("#%06x", n)
--     end
--   end
--
--   ---Parse `style` string into nvim_set_hl options
--   ---@param style string
--   ---@return table
--   local function parse_style(style)
--     if not style or style == "NONE" then
--       return {}
--     end
--
--     local result = {}
--     for token in string.gmatch(style, "([^,]+)") do
--       result[token] = true
--     end
--
--     return result
--   end
--
--   ---Get highlight opts for a given highlight group name
--   ---@param name string
--   ---@return table
--   local function get_highlight(name)
--     local hl = vim.api.nvim_get_hl_by_name(name, true)
--     if hl.link then
--       return get_highlight(hl.link)
--     end
--
--     local result = parse_style(hl.style)
--     result.fg = hl.foreground and hex(hl.foreground)
--     result.bg = hl.background and hex(hl.background)
--     result.sp = hl.special and hex(hl.special)
--
--     return result
--   end
--
--   ---Set highlight group from provided table
--   ---@param groups table
--   local function set_highlights(groups)
--     for group, opts in pairs(groups) do
--       vim.api.nvim_set_hl(0, group, opts)
--     end
--   end
--
--   ---Generate a color palette from the current applied colorscheme
--   ---@return table
--   local function generate_pallet_from_colorscheme()
--   -- stylua: ignore
--   local color_map = {
--     black   = { index = 0, default = "#393b44" },
--     red     = { index = 1, default = "#c94f6d" },
--     green   = { index = 2, default = "#81b29a" },
--     yellow  = { index = 3, default = "#dbc074" },
--     blue    = { index = 4, default = "#719cd6" },
--     magenta = { index = 5, default = "#9d79d6" },
--     cyan    = { index = 6, default = "#63cdcf" },
--     white   = { index = 7, default = "#dfdfe0" },
--   }
--
--     local pallet = {}
--     for name, value in pairs(color_map) do
--       local global_name = "terminal_color_" .. value.index
--       pallet[name] = vim.g[global_name] and vim.g[global_name] or value.default
--     end
--
--     pallet.sl = get_highlight "StatusLine"
--     pallet.tab = get_highlight "TabLine"
--     pallet.sel = get_highlight "TabLineSel"
--     pallet.fill = get_highlight "TabLineFill"
--
--     return pallet
--   end
--
--   ---Generate user highlight groups based on the curent applied colorscheme
--   ---
--   ---NOTE: This is a global because I dont known where this file will be in your config
--   ---and it is needed for the autocmd below
--   _G._genreate_user_tabline_highlights = function()
--     local pal = generate_pallet_from_colorscheme()
--
--   -- stylua: ignore
--   local sl_colors = {
--     Black   = { fg = pal.black,   bg = pal.white },
--     Red     = { fg = pal.red,     bg = pal.sl.bg },
--     Green   = { fg = pal.green,   bg = pal.sl.bg },
--     Yellow  = { fg = pal.yellow,  bg = pal.sl.bg },
--     Blue    = { fg = pal.blue,    bg = pal.sl.bg },
--     Magenta = { fg = pal.magenta, bg = pal.sl.bg },
--     Cyan    = { fg = pal.cyan,    bg = pal.sl.bg },
--     White   = { fg = pal.white,   bg = pal.black },
--   }
--
--     local colors = {}
--     for name, value in pairs(sl_colors) do
--       colors["User" .. name] = { fg = value.fg, bg = value.bg, bold = true }
--       colors["UserRv" .. name] = { fg = value.bg, bg = value.fg, bold = true }
--     end
--
--     local groups = {
--       -- tabline
--       UserTLHead = { fg = pal.fill.bg, bg = pal.cyan },
--       UserTLHeadSep = { fg = pal.cyan, bg = pal.fill.bg },
--       UserTLActive = { fg = pal.sel.fg, bg = pal.sel.bg, bold = true },
--       UserTLActiveSep = { fg = pal.sel.bg, bg = pal.fill.bg },
--       UserTLBoldLine = { fg = pal.tab.fg, bg = pal.tab.bg, bold = true },
--       UserTLLineSep = { fg = pal.tab.bg, bg = pal.fill.bg },
--     }
--
--     set_highlights(vim.tbl_extend("force", colors, groups))
--   end
--
--   _genreate_user_tabline_highlights()
--
--   vim.api.nvim_create_augroup("UserTablineHighlightGroups", { clear = true })
--   vim.api.nvim_create_autocmd({ "SessionLoadPost", "ColorScheme" }, {
--     callback = function()
--       _genreate_user_tabline_highlights()
--     end,
--   })
--
--   ----------------------------------------------------------------------------------------------------
--
--   local filename = require "tabby.filename"
--
--   local cwd = function()
--     return "  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
--   end
--
--   local line = {
--     hl = "TabLineFill",
--     layout = "active_wins_at_tail",
--     head = {
--       { cwd, hl = "UserTLHead" },
--       { "", hl = "UserTLHeadSep" },
--     },
--     active_tab = {
--       label = function(tabid)
--         return {
--           "  " .. tabid .. " ",
--           hl = "UserTLActive",
--         }
--       end,
--       left_sep = { "", hl = "UserTLActiveSep" },
--       right_sep = { "", hl = "UserTLActiveSep" },
--     },
--     inactive_tab = {
--       label = function(tabid)
--         return {
--           "  " .. tabid .. " ",
--           hl = "UserTLBoldLine",
--         }
--       end,
--       left_sep = { "", hl = "UserTLLineSep" },
--       right_sep = { "", hl = "UserTLLineSep" },
--     },
--     top_win = {
--       label = function(winid)
--         return {
--           "  " .. filename.unique(winid) .. " ",
--           hl = "TabLine",
--         }
--       end,
--       left_sep = { "", hl = "UserTLLineSep" },
--       right_sep = { "", hl = "UserTLLineSep" },
--     },
--     win = {
--       label = function(winid)
--         return {
--           "  " .. filename.unique(winid) .. " ",
--           hl = "TabLine",
--         }
--       end,
--       left_sep = { "", hl = "UserTLLineSep" },
--       right_sep = { "", hl = "UserTLLineSep" },
--     },
--     tail = {
--       { "", hl = "UserTLHeadSep" },
--       { "  ", hl = "UserTLHead" },
--     },
--     nerdfont = true, -- whether use nerdfont
--   }
--
--   -- require("tabby").setup {
--   --   tabline = line,
--   -- }
--
--  -- With LSP Info
-- -- function tab_name(tab)
-- --    return string.gsub(tab,"%[..%]","")
-- -- end
-- --
-- --
-- -- function tab_modified(tab)
-- --     wins = require("tabby.module.api").get_tab_wins(tab)
-- --     for i, x in pairs(wins) do
-- --         if vim.bo[vim.api.nvim_win_get_buf(x)].modified then
-- --             return ""
-- --         end
-- --     end
-- --     return ""
-- -- end
-- --
-- -- function lsp_diag(buf)
-- --     diagnostics = vim.diagnostic.get(buf)
-- --     local count = {0, 0, 0, 0}
-- --
-- --     for _, diagnostic in ipairs(diagnostics) do
-- --         count[diagnostic.severity] = count[diagnostic.severity] + 1
-- --     end
-- --     if count[1] > 0 then
-- --         return vim.bo[buf].modified and "" or ""
-- --     elseif count[2] > 0 then
-- --         return vim.bo[buf].modified and "" or ""
-- --     end
-- --     return vim.bo[buf].modified and "" or ""
-- -- end
-- --
-- -- local function get_modified(buf)
-- --     if vim.bo[buf].modified then
-- --         return ''
-- --     else
-- --         return ''
-- --     end
-- -- end
-- --
-- -- local function buffer_name(buf)
-- --     if string.find(buf,"NvimTree") then
-- --         return "NvimTree"
-- --     end
-- --     return buf
-- -- end
-- --
-- -- local theme = {
-- --   fill = 'TabLineFill',
-- --   -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
-- --   head = 'UserTLHead',
-- --   current_tab = 'TabLineSel',
-- --   inactive_tab = 'UserTLBoldLine',
-- --   tab = 'TabLine',
-- --   win = 'UserTLHead',
-- --   tail = 'UserTLHead',
-- -- }
-- -- require('tabby.tabline').set(function(line)
-- --   return {
-- --     {
-- --       { '  ', hl = theme.head },
-- --       line.sep('', theme.head, theme.fill),
-- --     },
-- --     line.tabs().foreach(function(tab)
-- --       local hl = tab.is_current() and theme.current_tab or theme.inactive_tab
-- --       return {
-- --         line.sep('', hl, theme.fill),
-- --         tab.number(),
-- --         "",
-- --         tab_name(tab.name()),
-- --         "",
-- --         tab_modified(tab.id),
-- --         line.sep('', hl, theme.fill),
-- --         hl = hl,
-- --         margin = ' ',
-- --       }
-- --     end),
-- --     line.spacer(),
-- --     line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
-- --       local hl = win.is_current() and theme.current_tab or theme.inactive_tab
-- --       return {
-- --         line.sep('', hl, theme.fill),
-- --         win.file_icon(),
-- --         "",
-- --         buffer_name(win.buf_name()),
-- --         "",
-- --         lsp_diag(win.buf().id),
-- --         line.sep('', hl, theme.fill),
-- --         hl = hl,
-- --         margin = ' ',
-- --       }
-- --     end),
-- --     {
-- --       line.sep('', theme.tail, theme.fill),
-- --       { '  ', hl = theme.tail },
-- --     },
-- --     hl = theme.fill,
-- --   }
-- -- end)

 -- Default:
local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLine',
  current_tab = 'TabLineSel',
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}

require('tabby').setup({
  line = function(line)
    return {
      {
        -- { '  ', hl = theme.head },
        { '  ', hl = theme.head },
        line.sep('', theme.head, theme.fill),
      },
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        return {
          line.sep('', hl, theme.fill),
          -- tab.is_current() and '' or '󰆣',
          tab.is_current() and " " or " ",
          tab.number(),
          tab.name(),
          tab.close_btn(''),
          line.sep('', hl, theme.fill),
          hl = hl,
          margin = ' ',
        }
      end),
      line.spacer(),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        return {
          line.sep('', theme.win, theme.fill),
          win.is_current() and '' or '',
          win.buf_name(),
          line.sep('', theme.win, theme.fill),
          hl = theme.win,
          margin = ' ',
        }
      end),
      {
        line.sep('', theme.tail, theme.fill),
        { '  ', hl = theme.tail },
      },
      hl = theme.fill,
    }
  end,
  -- option = {}, -- setup modules' option,
})

end

return M
