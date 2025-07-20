local M = {
  "gregorias/coerce.nvim",
  tag = "v4.1.0",
  config = true,
  -- event = "VeryLazy",
  opts = {
    default_mode_keymap_prefixes = {
      normal_mode = "co", -- Customize the normal mode prefix
      motion_mode = "go", -- Customize the motion mode prefix
      visual_mode = "go", -- Customize the visual mode prefix
    },
  },
}

return M
