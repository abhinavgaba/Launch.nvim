local M = {
  "RRethy/vim-illuminate",
  event = "VeryLazy",
}

function M.enableIlluminate(buf)
  local buf_name = vim.api.nvim_buf_get_name(buf)

  -- Don't run on buffers open via :Gitsigns diffthis etc.
  if string.find(buf_name, "gitsigns:") or string.find(buf_name, "diffview:") then
    return false
  end

  -- local max_filesize = 2000 * 1024 -- 2MB
  -- local ok, stats = pcall(vim.loop.fs_stat, buf_name)
  -- if ok and stats and stats.size > max_filesize then
  --   return false
  -- end

  return true
end

function M.config()
  require("illuminate").configure {
    filetypes_denylist = {
      "mason",
      "harpoon",
      "DressingInput",
      "NeogitCommitMessage",
      "qf",
      "dirvish",
      "oil",
      "minifiles",
      "fugitive",
      "alpha",
      "NvimTree",
      "lazy",
      "NeogitStatus",
      "Trouble",
      "netrw",
      "lir",
      "DiffviewFiles",
      "Outline",
      "Jaq",
      "spectre_panel",
      "toggleterm",
      "DressingSelect",
      "TelescopePrompt",
    },
    should_enable = M.enableIlluminate,
  }
end

return M
