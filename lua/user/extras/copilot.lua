local M = {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    "zbirenbaum/copilot-cmp",
  },
}

M.opts = {
  panel = {
    keymap = {
      jump_next = "<a-j>",
      jump_prev = "<a-k>",
      accept = "<a-l>",
      refresh = "r",
      open = "<a-c>",
    },
  },
  suggestion = {
    -- Use blink for suggestions
    auto_trigger = false,
    hide_during_completion = true,
    keymap = {
      accept = "<a-l>",
      next = "<a-j>",
      prev = "<a-k>",
      dismiss = "<a-h>",
    },
  },
  filetypes = {
    markdown = true,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    cvs = false,
    ["."] = false,
  },
  copilot_node_command = "node",
}

-- Use blink for suggestions. No need for this.
-- M.keys = {
--   {
--     "<leader>aC",
--     function()
--       require("copilot.suggestion").toggle_auto_trigger()
--     end,
--     desc = "Toggle Copilot Suggestion Autotrigger",
--   },
-- }

return M
