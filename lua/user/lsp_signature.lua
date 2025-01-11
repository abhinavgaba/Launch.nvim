--- @type LazyPluginSpec
local M = {
  "ray-x/lsp_signature.nvim",
  -- lazy-loading this may cause ordering issues with lspconfig.
  -- event = "VeryLazy",
}

return M
