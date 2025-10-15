local M = {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    "copilotlsp-nvim/copilot-lsp",
    init = function()
      vim.g.copilot_nes_debounce = 500
    end,
  },
}

M.opts = {
  nes = {
    enabled = true,
    keymap = {
      accept_and_goto = "<leader><space>",
      accept = "<s-space>",
      dismiss = "<Esc>",
    },
  },
  panel = {
    enabled = false,
  --   keymap = {
  --     jump_next = "<a-j>",
  --     jump_prev = "<a-k>",
  --     accept = "<a-l>",
  --     refresh = "r",
  --     open = "<a-c>",
  --   },
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
    help = true,
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
