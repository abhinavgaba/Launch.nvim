--- @type LazyPluginSpec
local M = {
  "williamboman/mason-lspconfig.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "williamboman/mason.nvim",
      opts = { ui = { border = "rounded" } },
      cmd = "Mason",
    },
  },
}

M.opts = {
  ensure_installed = {
    "lua_ls",
    "clangd",
    "fortls",
    "marksman",
    "texlab",
  },
}

return M
