local M = {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    {
      -- For prettier syntax highlighting
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "codecompanion" },
      },
      ft = function(_, ft)
        vim.list_extend(ft, { "codecompanion" })
      end,
    },
    {
      -- Use blink for completion of slash etc
      "saghen/blink.cmp",
      lazy = true,
      opts = {
        sources = {
          default = {
            "codecompanion",
          },
        },
      },
    },
    { "echasnovski/mini.diff" },
  },
  event = "VeryLazy",
  config = true,
}

M.opts = {
  display = {
    diff = {
      provider = "mini_diff",
    },
  },
  strategies = {
    chat = {
      adapter = "copilot",
      -- Use fzf_lua for slash commands
      slash_commands = {
        ["buffer"] = {
          opts = {
            provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
          },
        },
        ["file"] = {
          opts = {
            provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
          },
        },
        ["help"] = {
          opts = {
            provider = "fzf_lua", -- telescope|mini_pick|fzf_lua
          },
        },
        ["symbols"] = {
          opts = {
            provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
          },
        },
      },
    },
    -- inline = {
    --   adapter = "copilot",
    -- },
  },
}

return M
