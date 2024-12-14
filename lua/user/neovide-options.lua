if not vim.g.neovide then
  return
end

-- Only if running as part of neovide
vim.print(vim.g.neovide_version)
vim.o.guifont = "Lilex:h11"
