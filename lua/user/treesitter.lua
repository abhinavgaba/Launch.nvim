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
  dependencies = { "jay-babu/mason-null-ls.nvim" },
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
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

local function wait_for_treesitter_cli(on_ready)
  local attempts = 0
  local max_attempts = 10
  local interval = 2000 -- ms

  local timer = vim.uv.new_timer()
  timer:start(interval, interval, vim.schedule_wrap(function()
    attempts = attempts + 1
    if vim.fn.executable "tree-sitter" == 1 then
      timer:stop()
      timer:close()
      on_ready()
    elseif attempts >= max_attempts then
      timer:stop()
      timer:close()
      vim.notify(
        "nvim-treesitter: tree-sitter CLI not found. Run :MasonInstall tree-sitter-cli",
        vim.log.levels.WARN
      )
    end
  end))
end

function M.config()
  local function install()
    require("nvim-treesitter.install").install(langs)
  end

  if vim.fn.executable "tree-sitter" == 1 then
    install()
  else
    wait_for_treesitter_cli(install)
  end
end

return M
