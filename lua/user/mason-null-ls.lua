--- @type LazyPluginSpec
local M = {
  "jay-babu/mason-null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
}

M.opts = {
  ensure_installed = {
    "beautysh",
    "clang-format",
    "findent",
    "fprettify",
    -- "prettier",
    "stylua",
  },
  automatic_installation = false,
  handlers = {},
}

return M
