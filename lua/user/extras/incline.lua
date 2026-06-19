local M = {
  "b0o/incline.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
}

function M.config()
  local helpers = require "incline.helpers"
  local devicons = require "nvim-web-devicons"
  local vcs = require "user.custom.vcs-bufname"

  -- Use Snacks.toggle so the on/off state shows up in which-key.
  Snacks.toggle
    .new({
      name = "Incline (filename label)",
      get = function()
        return require("incline").is_enabled()
      end,
      set = function(state)
        if state then
          require("incline").enable()
        else
          require("incline").disable()
        end
      end,
    })
    :map "<Leader>ti"

  require("incline").setup {
    window = {
      padding = 0,
      margin = { horizontal = 0 },
    },
    -- Diff virtual buffers (CodeDiff, Fugitive, Diffview's base side) are unlisted
    -- and use a special buftype, so incline's defaults hide them. Allow them through
    -- while otherwise preserving the stock "ignore special buftypes" behavior.
    ignore = {
      -- We must allow unlisted buffers through this gate, otherwise the diff
      -- virtual buffers (which are unlisted) never reach the buftypes check
      -- below. The unlisted filtering is instead reapplied there, so the VCS
      -- whitelist stays the *only* relaxation.
      unlisted_buffers = false,
      -- Diffview's side panels (file list, history, option panel) are not diff
      -- content and should stay label-free.
      filetypes = { "DiffviewFiles", "DiffviewFileHistory" },
      buftypes = function(bufnr, buftype)
        -- Always show on recognized diff/VCS buffers.
        if vcs.parse(vim.api.nvim_buf_get_name(bufnr)) then
          return false
        end
        -- Otherwise reproduce the stock defaults: ignore special buftypes and
        -- (since we disabled it above) unlisted buffers.
        if buftype ~= "" then
          return true
        end
        return not vim.bo[bufnr].buflisted
      end,
    },
    render = function(props)
      local bufname = vim.api.nvim_buf_get_name(props.buf)

      -- For VCS / diff virtual buffers, derive the filename from the parsed path
      -- and show the revision after it (e.g. "init.lua @ a1b2c3d"), matching dropbar.
      local vcs_path, vcs_rev = vcs.parse(bufname)
      local filename = vim.fn.fnamemodify(vcs_path or bufname, ":t")
      if filename == "" then
        filename = "[No Name]"
      end
      local ft_icon, ft_color = devicons.get_icon_color(filename)
      local modified = vim.bo[props.buf].modified
      return {
        ft_icon and { " ", ft_icon, " ", guibg = ft_color, guifg = helpers.contrast_color(ft_color) } or "",
        " ",
        { filename, gui = modified and "bold,italic" or "bold" },
        vcs_rev and { " @ " .. vcs.short_rev(vcs_rev), gui = "italic", guifg = "#a89984" } or "",
        " ",
        guibg = "#44406e",
      }
    end,
  }
end

return M
