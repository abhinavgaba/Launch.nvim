local M = {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPost", "BufNewFile" },
  build = ":TSUpdate",
}

function M.config()
  require("nvim-treesitter.configs").setup {
    ensure_installed = {
      "asm",
      "bash",
      "c",
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
    },

    highlight = { enable = true },
    indent = { enable = true },
    additional_vim_regex_highlighting = false,

    -- FIXME: This is not working for some reason.
    disable = function(lang, buf)
      local buf_name = vim.api.nvim_buf_get_name(buf)
      print(': bufname is ' .. vim.inspect(buf_name))

      -- Don't run on buffers open via :Gitsigns diffthis etc.
      if string.find(buf_name, "gitsigns:") then
        return true
      end

      -- Disable slow treesitter highlight for large files
      local max_filesize = 2000 * 1024 -- 2MB
      local ok, stats = pcall(vim.loop.fs_stat, buf_name)
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end,
  }
end

return M
