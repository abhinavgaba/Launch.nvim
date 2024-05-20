local M = {
  "jay-babu/mason-null-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim",
  },
}

function M.config()
  local servers = {
    "beautysh",
    "clang-format",
    "findent",
    "fprettify",
    -- "prettier",
    "stylua",
  }

  require("mason-null-ls").setup({
    ensure_installed = servers,
    automatic_installation = false,
    handlers = {},
  })
end

return M
