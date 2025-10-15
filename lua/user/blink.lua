local M = {
  "saghen/blink.cmp",
  event = "InsertEnter",
  -- optional: provides snippets for the snippet source
  -- dependencies = "rafamadriz/friendly-snippets",
  dependencies = { "fang2hou/blink-copilot" },

  -- use a release tag to download pre-built binaries
  version = "v1.*",
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- 'default' for mappings similar to built-in completion
    -- 'super-tab' for mappings similar to vscode (tab to accept, arrow keys to navigate)
    -- 'enter' for mappings similar to 'super-tab' but with 'enter' to accept
    -- see the "default configuration" section below for full documentation on how to define
    -- your own keymap.
    keymap = {
      -- Use both c-y and tab to accept, use a-j/k to navigate.
      preset = "super-tab",
      ["<c-y>"] = { "select_and_accept" },
      ["<c-k>"] = { "select_prev", "fallback" },
      ["<c-j>"] = { "select_next", "fallback" },
      ["<c-b>"] = {},
      ["<c-f>"] = {},
      ["<c-u>"] = { "scroll_documentation_up", "fallback" },
      ["<c-d>"] = { "scroll_documentation_down", "fallback" },
    -- Keymap needed with copilot-lsp, to enable NES, but copilot.lua handles
    -- this mapping by itself.
    --   ["<Tab>"] = {
    --     function(cmp)
    --       if vim.b[vim.api.nvim_get_current_buf()].nes_state then
    --         cmp.hide()
    --         return (
    --           require("copilot-lsp.nes").apply_pending_nes()
    --           and require("copilot-lsp.nes").walk_cursor_end_edit()
    --         )
    --       end
    --       if cmp.snippet_active() then
    --         return cmp.accept()
    --       else
    --         return cmp.select_and_accept()
    --       end
    --     end,
    --     "snippet_forward",
    --     "fallback",
    --   },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      -- ghost_text = {enabled = true},
    },
    appearance = {
      -- Sets the fallback highlight groups to nvim-cmp's highlight groups
      -- Useful for when your theme doesn't support blink.cmp
      -- will be removed in a future release
      use_nvim_cmp_as_default = false,
      -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",
    },

    -- default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "copilot", "lsp", "path", "buffer" },
      -- optionally disable cmdline completions
      -- cmdline = {},
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 1000,
          async = true,
        },
        lsp = {
          score_offset = 400,
        },
        path = {
          score_offset = 300,
        },
        buffer = {
          score_offset = 200,
        },
        snippets = {
          score_offset = 100,
        },
      },
    },

    -- Use lsp-signature for signature help for now
    -- experimental signature help support
    -- signature = { enabled = true },
  },
  -- allows extending the providers array elsewhere in your config
  -- without having to redefine it
  opts_extend = { "sources.default" },
}

return M
