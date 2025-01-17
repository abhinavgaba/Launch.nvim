local M = {
  "giuxtaposition/blink-cmp-copilot",
  event = "InsertEnter",
  dependencies = {
    {
      "saghen/blink.cmp",
      opts = {
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "copilot" },
          providers = {
            copilot = {
              name = "copilot",
              module = "blink-cmp-copilot",
              score_offset = 500,
              async = false,
              timeout_ms = 2000,
              transform_items = function(_, items)
                local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                local kind_idx = #CompletionItemKind + 1
                CompletionItemKind[kind_idx] = "Copilot"
                for _, item in ipairs(items) do
                  item.kind = kind_idx
                end
                return items
              end,
            },
          },
        },
        appearance = {
          -- Blink does not expose its default kind icons so you must copy them all (or set your custom ones) and add Copilot
          kind_icons = {
            Copilot = require("user.icons").ui.Copilot,
            Text = "󰉿",
            Method = "󰊕",
            Function = "󰊕",
            Constructor = "󰒓",

            Field = "󰜢",
            Variable = "󰆦",
            Property = "󰖷",

            Class = "󱡠",
            Interface = "󱡠",
            Struct = "󱡠",
            Module = "󰅩",

            Unit = "󰪚",
            Value = "󰦨",
            Enum = "󰦨",
            EnumMember = "󰦨",

            Keyword = "󰻾",
            Constant = "󰏿",

            Snippet = "󱄽",
            Color = "󰏘",
            File = "󰈔",
            Reference = "󰬲",
            Folder = "󰉋",
            Event = "󱐋",
            Operator = "󰪚",
            TypeParameter = "󰬛",
          },
        },
      },
    },
    {
      "zbirenbaum/copilot.lua",
      opts = {
        panel = { enabled = false },
        suggestion = { enabled = false },
      },
    },
  },
}

return M
