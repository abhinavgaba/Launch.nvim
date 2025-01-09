local M = {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  dependencies = {
    "zbirenbaum/copilot-cmp",
  },
}

function M.config()
  require("copilot").setup {
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
      enabled = true,
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

  local opts = { noremap = true, silent = true, desc = "Toggle Copilot Suggestion Autotrigger" }
  vim.api.nvim_set_keymap("n", "<leader>aC", ":lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)

  -- require("copilot_cmp").setup()
end

return M
