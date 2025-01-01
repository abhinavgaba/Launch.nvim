local M = {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
}

M.opts = {
  preset = "helix",
  defaults = {},
  spec = {
    {
      mode = { "n", "v" },
      { "<leader><tab>", group = "tabs" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "debug" },
      { "<leader>p", group = "profiler" },
      { "<leader>f", group = "file/find" },
      { "<leader>g", group = "git" },
      { "<leader>s", group = "search" },
      { "<leader>gd", group = "diff vs ..." },
      { "<leader>u", group = "ui", icon = { icon = "󰙵 ", color = "cyan" } },
      { "<leader>x", group = "diagnostics/quickfix", icon = { icon = "󱖫 ", color = "green" } },
      { "<leader>t", group = "toggles" },
      { "[", group = "prev" },
      { "]", group = "next" },
      { "g", group = "goto" },
      { "gs", group = "surround" },
      { "z", group = "fold" },
      {
        "<leader>b",
        group = "buffer",
        expand = function()
          return require("which-key.extras").expand.buf()
        end,
      },
      {
        "<leader>w",
        group = "windows",
        proxy = "<c-w>",
        expand = function()
          return require("which-key.extras").expand.win()
        end,
      },
      -- better descriptions
      { "gx", desc = "Open with system app" },
    },
  },
}

M.keys = {
  {
    "<leader>?",
    function()
      require("which-key").show { global = false }
    end,
    desc = "Buffer Keymaps (which-key)",
  },
  {
    "<c-w><space>",
    function()
      require("which-key").show { keys = "<c-w>", loop = true }
    end,
    desc = "Window Hydra Mode (which-key)",
  },
}

function M.config(_, opts)
  local which_key = require "which-key"
  which_key.setup(opts)

  -- which_key.setup {
  --   plugins = {
  --     marks = true,
  --     registers = true,
  --     spelling = {
  --       enabled = true,
  --       suggestions = 20,
  --     },
  --     -- presets = {
  --     --   operators = false,
  --     --   motions = false,
  --     --   text_objects = false,
  --     --   windows = false,
  --     --   nav = false,
  --     --   z = false,
  --     --   g = false,
  --     -- },
  --   },
  --   win = {
  --     -- padding = { 2, 2, 2, 2 },
  --     border = "rounded",
  --   },
  --   -- ignore_missing = true,
  --   -- show_help = false,
  --   -- show_keys = false,
  --   disable = {
  --     buftypes = {},
  --     filetypes = { "TelescopePrompt" },
  --   },
  -- }
  --
  -- local opts = {
  --   mode = "n", -- NORMAL mode
  --   prefix = "<leader>",
  -- }
  --
  -- which_key.add(mappings, opts)
end

return M
