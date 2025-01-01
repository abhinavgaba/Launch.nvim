-- A small collection of QOL plugins.
local M = {
  "folke/snacks.nvim",
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons', 'nvim-tree/nvim-web-devicons' },
  priority = 1000,
  lazy = false,

  ---@type snacks.Config
  opts = {
    animate = {enabled = true},
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    indent = { enabled = false },
    input = { enabled = true },
    notifier = { enabled = false },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    scope = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = false }, -- illuminate does this too
    zen = {enabled = false},
    lazygit = {enabled = true},
    gitbrowse = {enabled = false},
    git = {enabled = true},
    profiler = {},
  },
    keys = {
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    -- { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    -- { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    { "<leader>ps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Bufer" },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
}

function M.config(_, opts)
  local notify = vim.notify
  require("snacks").setup(opts)
  -- HACK: restore vim.notify after snacks setup and let noice.nvim take over
  -- this is needed to have early notifications show up in noice history
  local noice_present, _ = pcall(require, "noice")
  if noice_present then
    vim.notify = notify
  end
end

function M.init()
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      -- Setup some globals for debugging (lazy-loaded)
      _G.dd = function(...)
        Snacks.debug.inspect(...)
      end
      _G.bt = function()
        Snacks.debug.backtrace()
      end
      vim.print = _G.dd -- Override print to use snacks for `:=` command

      -- Create some toggle mappings
      Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>ts"
      Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>tw"
      Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>tL"
      Snacks.toggle.diagnostics():map "<leader>td"
      Snacks.toggle.line_number():map "<leader>tl"
      Snacks.toggle
        .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
        :map "<leader>tc"
      Snacks.toggle.treesitter():map "<leader>tT"
      Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>tb"
      Snacks.toggle.inlay_hints():map "<leader>th"
      -- Snacks.toggle.indent():map "<leader>tg"
      Snacks.toggle.dim():map "<leader>tD"
      -- Toggle the profiler
      Snacks.toggle.profiler():map("<leader>pp")
      -- Toggle the profiler highlights
      Snacks.toggle.profiler_highlights():map("<leader>ph")
    end,
  })
end

return M
