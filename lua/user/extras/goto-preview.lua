local M = {
  "rmagatti/goto-preview",
  event = "VeryLazy",
}

function M.config()
  require("goto-preview").setup {
    default_mappings = true,
  }
end

return M
