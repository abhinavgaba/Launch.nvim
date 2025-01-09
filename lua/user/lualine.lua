local M = {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "AndreM222/copilot-lualine",
    "meuter/lualine-so-fancy.nvim",
  },
}

--------------------------------------------------------------------------------
-- Custom functions from lualine wiki
--------------------------------------------------------------------------------
-- Currently active keymap
local function keymap()
  if vim.opt.iminsert:get() > 0 and vim.b.keymap_name then
    return "⌨ " .. vim.b.keymap_name
  end
  return ""
end

--- @param trunc_width number trunctates component when screen width is less then trunc_width
--- @param trunc_len number truncates component to trunc_len number of chars
--- @param hide_width number hides component when window width is smaller then hide_width
--- @param no_ellipsis boolean whether to disable adding '...' at end after truncation
--- return function that can format the component accordingly
local function trunc(trunc_width, trunc_len, hide_width, no_ellipsis)
  return function(str)
    local win_width = vim.fn.winwidth(0)
    if hide_width and win_width < hide_width then
      return ""
    elseif trunc_width and trunc_len and win_width < trunc_width and #str > trunc_len then
      return str:sub(1, trunc_len) .. (no_ellipsis and "" or "...")
    end
    return str
  end
end

--------------------------------------------------------------------------------
-- Lualine-fancy config
--------------------------------------------------------------------------------
function M.config()
  local lualine = require "lualine"
  local options = {
    options = {
      theme = "ayu_mirage",
      icons_enabled = true,
      component_separators = { left = "│", right = "│" },
      section_separators = { left = "", right = "" },
      -- component_separators = { left = '', right = ''},
      -- section_separators = { left = '', right = ''},
      -- component_separators = { left = '', right = ''},
      -- section_separators = { left = '', right = ''},
      -- component_separators = { left = "", right = "" },
      -- section_separators = { left = "", right = "" },
      -- section_separators = { left = '', right = '' },
      -- component_separators = { left = '', right = '' },
      globalstatus = true,
      refresh = {
        statusline = 100,
      },
    },
    sections = {
      lualine_a = {
        { "fancy_mode", width = 1 },
      },
      lualine_b = {
        { "fancy_branch", fmt = trunc(0, 0, 120, true) },
        { "fancy_diff", fmt = trunc(0, 0, 25, true) },
      },
      lualine_c = {
        { "fancy_cwd", substitute_home = true, fmt = trunc(0, 0, 60, true) },
        {
          "filename",
          file_status = true, -- displays file status (readonly status, modified status)
          path = 1, -- 1: Relative Path
          shorting_target = 40, -- Shortens path to leave 40 spaces in the window
          symbols = {
            modified = "✏️", -- eText to show when the file is modified.
            readonly = "🔒", -- Text to show when the file is non-modifiable or readonly.
            newfile = " ",
            unnamed = "",
          },
          fmt = trunc(30, 40, 30, false),
        },
      },
      lualine_x = {
        { "copilot", fmt = trunc(0, 0, 120, true) },
        { "fancy_macro", fmt = trunc(0, 0, 120, true) },
        { keymap, fmt = trunc(0, 0, 120, true) },
        { "fancy_diagnostics", fmt = trunc(0, 0, 50, true) },
        { "fancy_searchcount", fmt = trunc(0, 0, 50, true) },
        { "selectioncount", fmt = trunc(0, 0, 50, true) },
        { "fancy_location" },
      },
      lualine_y = {
        { "fancy_filetype", ts_icon = "", fmt = trunc(0, 0, 60, true) },
      },
      lualine_z = {
        { "fancy_lsp_servers", fmt = trunc(0, 0, 120, true) },
      },
    },
    extensions = { "quickfix", "man", "mason", "fugitive", "trouble", "lazy" },
  }

  -- Add snacks profiler status, if present
  local snacks_present, snacks = pcall(require, "snacks")
  if snacks_present then
    table.insert(options.sections.lualine_x, snacks.profiler.status())
  end

  lualine.setup(options)
end

return M
