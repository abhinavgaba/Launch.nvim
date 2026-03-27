local M = {
  "abhinavgaba/omp-maptype-info.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  keys = { "<leader>dh", "<leader>dd", "<leader>dm", "<leader>dM" },
  cmd = { "OmpMapTypeSync" },
  opts = {
    keymaps = {
      hex = "<leader>dh",
      dec = "<leader>dd",
      maptype = "<leader>dm",
      cheatsheet = "<leader>dM",
    },
  },
}

return M
