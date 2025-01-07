local M = {
  "mbbill/undotree",
  event = "VeryLazy",
}

-- HACK: undotree doesn't seem to expose its visibility status.
local function is_undotree_visible()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
    local filename = vim.fn.fnamemodify(bufname, ":t") -- Extract the filename
    if filename:match "^undotree_%d+$" then
      return true
    end
  end
  return false
end

local function set_toggle_keymap()
  local lazy_utils = require "user.lazy-utils"
  local has_snacks = lazy_utils.has "snacks.nvim"
  if not has_snacks then
    vim.keymap.set("n", "<leader>tu", "<cmd>UndotreeToggle<cr>", { desc = "Undo-tree Toggle" })
    return
  end

  lazy_utils.on_load("snacks.nvim", function()
    Snacks.toggle({
      name = "Undo-tree",
      get = function()
        return is_undotree_visible()
      end,
      set = function(state)
        if state then
          vim.cmd.UndotreeShow()
          vim.cmd.UndotreeFocus()
        else
          vim.cmd.UndotreeHide()
        end
      end,
    }):map "<leader>tu"
  end)
end

function M.config()
  set_toggle_keymap()
end
return M
