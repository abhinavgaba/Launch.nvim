local M = {
  "rmagatti/goto-preview",
  event = "VeryLazy",
}

function M.config()
  require("goto-preview").setup {
    default_mappings = false,
  }
end

function M.init()
  require("user.lazy-utils").on_very_lazy(function()
    vim.keymap.set("n", "gld", require("goto-preview").goto_preview_definition, { desc = "Preview definition" })
    vim.keymap.set(
      "n",
      "glt",
      require("goto-preview").goto_preview_type_definition,
      { desc = "Preview type definition" }
    )
    vim.keymap.set("n", "gli", require("goto-preview").goto_preview_implementation, {
      desc = "Preview implementation",
    })
    vim.keymap.set("n", "glD", require("goto-preview").goto_preview_declaration, {
      desc = "Preview declaration",
    })
    vim.keymap.set("n", "glr", require("goto-preview").goto_preview_references, { desc = "Preview references" })
    vim.keymap.set("n", "glq", require("goto-preview").close_all_win, { desc = "Close preview windows" })

  end)
end

return M
