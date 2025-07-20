-- lazy.nvim
local M = {
  "folke/noice.nvim",
  event = "VeryLazy",
  config = true,
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    -- "rcarriga/nvim-notify",
  },
}

---@type NoiceConfig
M.opts = {
  lsp = {
    progress = {
      enabled = false,
    },
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
    },
    signature = {
      -- lsp-signature is still better
      auto_open = { enabled = false },
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true, -- use a classic bottom cmdline for search
    command_palette = true, -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false, -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = true, -- add a border to hover docs and signature help
  },
  cmdline = {
    view = "cmdline",
  },
  --- @type NoiceConfigViews
  views = {
    cmdline_view_for_minialign = {
      backend = "popup",
      relative = "editor",
      reverse = true,
      position = {
        row = "100%",
        col = 0,
      },
      size = {
        height = 1,
        width = "100%",
      },
      border = {
        style = "none",
      },
      win_options = {
        winhighlight = {
          Normal = "NoiceCmdline",
        },
      },
    },
    -- mini = {
    --   backend = "mini",
    --   relative = "editor",
    --   align = "message-right",
    --   timeout = 2000,
    --   reverse = true,
    --   focusable = false,
    --   position = {
    --     row = -1,
    --     col = "100%",
     --     -- col = 0,
    --   },
    --   size = "auto",
    --   border = {
     --     style = "none",
    --   },
    --   zindex = 60,
    --   },
    -- cmdline_popup = {
    --   backend = "popup",
    --   relative = "editor",
    --   focusable = false,
    --   enter = false,
    --   zindex = 200,
    --   position = {
    --     row = "50%",
    --     col = "50%",
    --   },
    --   size = {
    --     min_width = 60,
    --     width = "auto",
    --     height = "auto",
    --   },
    --   border = {
    --     style = "rounded",
    --     padding = { 0, 1 },
    --   },
    --   win_options = {
    --     winhighlight = {
    --       Normal = "NoiceCmdlinePopup",
    --       FloatTitle = "NoiceCmdlinePopupTitle",
    --       FloatBorder = "NoiceCmdlinePopupBorder",
    --       IncSearch = "",
    --       CurSearch = "",
    --       Search = "",
    --     },
    --     winbar = "",
    --     foldenable = false,
    --     cursorline = false,
    --   },
    -- },
    -- -- cmdline_input = {
    --   view = "cmdline_popup",
    -- relative = "cursor",
    -- anchor = "auto",
    -- position = { row = 2, col = 2 },
    -- size = {
    --   min_width = 20,
    --   width = "auto",
    --   height = "auto",
    -- },
    -- },
  },
  -- routes = {
  --   {
  --     filter = { event = "msg_show", find = "mini.align" },
  --     filter_opts = { reverse = true },
  --     view = "cmdline_view_for_minialign",
  --     -- opts = { timeout = 10000 },
  --   },
  -- },
}

return M
