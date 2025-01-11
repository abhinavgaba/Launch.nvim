-- Show virtual text with reference count close to a symbol
local M = {
  "Wansmer/symbol-usage.nvim",
  event = "LspAttach", -- need run before LspAttach if you use nvim 0.9. On 0.10 use 'LspAttach'
  config = true,
}

---@type UserOpts
M.opts = {
  definition = { enabled = true },
  implementation = { enabled = true },
  vt_position = "end_of_line",
}

return M
