local M = {
  "yetone/avante.nvim",
  event = "VeryLazy",
  version = false, -- set this if you want to always pull the latest change
  keys = {
    { "<leader>a", "", desc = "ai" },
  },
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "saghen/blink.cmp", -- Use blink for autocompletion
    -- "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
    "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
    {
      "zbirenbaum/copilot.lua",
      lazy = true,
      opts = {
        panel = { enabled = false },
        suggestion = { enabled = false },
      },
    },
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "Avante" },
      },
      ft = function(_, ft)
        vim.list_extend(ft, { "Avante" })
      end,
    },
    -- support for image pasting
    "HakonHarnes/img-clip.nvim",
    {
      "saghen/blink.compat",
      lazy = true,
      opts = {},
      config = function()
        -- monkeypatch cmp.ConfirmBehavior for Avante
        require("cmp").ConfirmBehavior = {
          Insert = "insert",
          Replace = "replace",
        }
      end,
    },
    {
      "saghen/blink.cmp",
      lazy = true,
      opts = {
        sources = {
          default = {
            "avante_commands",
            "avante_mentions",
            "avante_files",
          },
          providers = {
            avante_commands = {
              name = "avante_commands",
              module = "blink.compat.source",
              score_offset = 90, -- show at a higher priority than lsp
              opts = {},
            },
            avante_files = {
              name = "avante_commands",
              module = "blink.compat.source",
              score_offset = 100, -- show at a higher priority than lsp
              opts = {},
            },
            avante_mentions = {
              name = "avante_mentions",
              module = "blink.compat.source",
              score_offset = 1000, -- show at a higher priority than lsp
              opts = {},
            },
          },
        },
      },
    },
  },
  build = "make",
  opts = {
    provider = "copilot",
    auto_suggestions_provider = "copilot",
    copilot = { model = "claude-3.7-sonnet" },
    hints = { enabled = true },
    file_selector = {
      provider = "fzf",
      provider_opts = {},
    },
    -- recommended settings
    embed_image_as_base64 = false,
    prompt_for_file_name = false,
    drag_and_drop = {
      insert_mode = true,
    },
  },
}

return M
