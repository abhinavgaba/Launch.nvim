local langs = {
  "asm",
  "bash",
  "c",
  "cpp",
  "cmake",
  "diff",
  "fortran",
  "llvm",
  "lua",
  "make",
  "markdown",
  "markdown_inline",
  "ssh_config",
  "tablegen",
  "vim",
}

local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = function()
    local ts = require("nvim-treesitter")
    ts.install(langs)
    ts.update()
  end,
}

-- function M.disableNvimTS(_, buf)
--   local buf_name = vim.api.nvim_buf_get_name(buf)
--
--   -- Don't run on buffers open via :Gitsigns diffthis etc.
--   if string.find(buf_name, "gitsigns:") or string.find(buf_name, "diffview:") or string.find(buf_name, "fugitive:") then
--     return true
--   end
--
--   -- Disable slow treesitter highlight for large files
--   -- local max_filesize = 2000 * 1024 -- 2MB
--   -- local ok, stats = pcall(vim.loop.fs_stat, buf_name)
--   -- if ok and stats and stats.size > max_filesize then
--   --   return true
--   -- end
-- end

function M.config()
  -- Enable treesitter highlighting per buffer
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      pcall(vim.treesitter.start, args.buf)
    end,
  })
end

return M
