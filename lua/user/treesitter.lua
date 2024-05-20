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
    },

    highlight = { enable = true },
    indent = { enable = true },
  }
end

return M
