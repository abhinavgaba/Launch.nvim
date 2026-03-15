local M = {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = {
      split_side = "right",
      split_width_percentage = 0.35,
      provider = "snacks",
    },
  },
  keys = {
    { "<leader>cct", "<cmd>ClaudeCode<cr>",            desc = "Toggle" },
    { "<leader>ccf", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus" },
    { "<leader>ccr", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume" },
    { "<leader>ccC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue" },
    { "<leader>ccm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Model" },
    { "<leader>ccb", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add Buffer" },
    { "<leader>ccs", "<cmd>ClaudeCodeSend<cr>",        desc = "Send Selection", mode = "v" },
    { "<leader>cca", "<cmd>ClaudeCodeDiffAccept<cr>",  desc = "Accept Diff" },
    { "<leader>ccd", "<cmd>ClaudeCodeDiffDeny<cr>",    desc = "Deny Diff" },
  },
}

return M
