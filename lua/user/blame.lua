local M = {
  "FabijanZulj/blame.nvim",
  event = "VeryLazy",
  keys = {
    { "<leader>gx", "<cmd>BlameToggle<CR>", desc = "Git Blame eXtended (blame.nvim)" },
  },
}

function M.config()
  local blame = require "blame"
  -- local formats = require "blame.formats.default_formats"
  local mappings = {
    commit_info = "K",
    stack_push = "<TAB>",
    stack_pop = "<S-TAB>",
    show_commit = "<CR>",
    close = { "<esc>", "q" },
    copy_hash = "y",
    open_in_browser = "o",
  }

  blame.setup {
    date_format = "%Y/%m/%d",
    -- virtual_style = "right",
    merge_consecutive = true,
    -- max_summary_width = 30,
    -- colors = nil,
    commit_detail_view = "vsplit",
    -- format_fn = formats.commit_date_author_fn,
    mappings = mappings,
  }
end

return M
