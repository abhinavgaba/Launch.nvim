-- Mostly based on LazyVim.
local M = {
  "ibhagwan/fzf-lua",
}

function M.opts()
  local config = require "fzf-lua.config"
  local actions = require "fzf-lua.actions"

  -- Quickfix
  config.defaults.keymap.fzf["ctrl-q"] = "select-all+accept"
  config.defaults.keymap.fzf["ctrl-u"] = "half-page-up"
  config.defaults.keymap.fzf["ctrl-d"] = "half-page-down"
  config.defaults.keymap.fzf["ctrl-x"] = "jump"
  config.defaults.keymap.fzf["ctrl-f"] = "preview-page-down"
  config.defaults.keymap.fzf["ctrl-b"] = "preview-page-up"
  config.defaults.keymap.builtin["<c-f>"] = "preview-page-down"
  config.defaults.keymap.builtin["<c-b>"] = "preview-page-up"

  local lazy_utils = require "user.lazy-utils"

  -- Trouble
  if lazy_utils.has "trouble.nvim" then
    config.defaults.actions.files["ctrl-t"] = require("trouble.sources.fzf").actions.open
  end

  local img_previewer ---@type string[]?
  for _, v in ipairs {
    { cmd = "ueberzug", args = {} },
    { cmd = "chafa", args = { "{file}", "--format=symbols" } },
    { cmd = "viu", args = { "-b" } },
  } do
    if vim.fn.executable(v.cmd) == 1 then
      img_previewer = vim.list_extend({ v.cmd }, v.args)
      break
    end
  end

  return {
    "default-title",
    fzf_colors = true,
    fzf_opts = {
      ["--no-scrollbar"] = true,
    },
    defaults = {
      -- formatter = "path.filename_first",
      formatter = "path.dirname_first",
    },
    previewers = {
      builtin = {
        -- fzf-lua is very fast, but it really struggled to preview a couple files
        -- in a repo. Those files were very big JavaScript files (1MB, minified, all on a single line).
        -- It turns out it was Treesitter having trouble parsing the files.
        -- With this change, the previewer will not add syntax highlighting to files larger than 100KB
        -- (Yes, I know you shouldn't have 100KB minified files in source control.)
        syntax_limit_b = 1024 * 1000, -- 1000KB
        extensions = {
          ["png"] = img_previewer,
          ["jpg"] = img_previewer,
          ["jpeg"] = img_previewer,
          ["gif"] = img_previewer,
          ["webp"] = img_previewer,
        },
        ueberzug_scaler = "fit_contain",
      },
    },
    winopts = {
      width = 0.8,
      height = 0.8,
      row = 0.5,
      col = 0.5,
      preview = {
        scrollchars = { "┃", "" },
      },
    },
    files = {
      cwd_prompt = false,
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
    },
    grep = {
      -- One thing I missed from Telescope was the ability to live_grep and the
      -- run a filter on the filenames.
      -- Ex: Find all occurrences of "enable" but only in the "plugins" directory.
      -- With this change, I can sort of get the same behaviour in live_grep.
      -- ex: > enable --*/plugins/*
      -- I still find this a bit cumbersome. There's probably a better way of doing this.
      rg_glob = true, -- enable glob parsing
      glob_flag = "--iglob", -- case insensitive globs
      glob_separator = "%s%-%-", -- query separator pattern (lua): ' --'
      actions = {
        ["alt-i"] = { actions.toggle_ignore },
        ["alt-h"] = { actions.toggle_hidden },
      },
    },
    lsp = {
      symbols = {
        symbol_hl = function(s)
          return "TroubleIcon" .. s
        end,
        symbol_fmt = function(s)
          return s:lower() .. "\t"
        end,
        child_prefix = false,
      },
      code_actions = {
        previewer = vim.fn.executable "delta" == 1 and "codeaction_native" or nil,
      },
    },
    oldfiles = {
      -- In Telescope, when I used <leader>fr, it would load old buffers.
      -- fzf lua does the same, but by default buffers visited in the current
      -- session are not included. I use <leader>fr all the time to switch
      -- back to buffers I was just in. If you missed this from Telescope,
      -- give it a try.
      include_current_session = true,
    },
  }
end
M.keys = {
  { "<c-j>", "<c-j>", ft = "fzf", mode = "t", nowait = true },
  { "<c-k>", "<c-k>", ft = "fzf", mode = "t", nowait = true },
  {
    "<leader>,",
    "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>",
    desc = "Switch Buffer",
  },
  -- { "<leader>/", "<cmd>FzfLua live_grep<cr>", desc = "Grep (cwd)" },
  { "<leader>:", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
  { "<leader><space>", "<cmd>FzfLua files<cr>", desc = "Find Files (cwd)" },
  -- find
  { "<leader>fb", "<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers" },
  { "<leader>fc", "<cmd>FzfLua files cwd=~/.nvim<cr>", desc = "Find Config Files" },
  { "<leader>ff", "<cmd>FzfLua files<cr>", desc = "Find Files (cwd)" },
  { "<leader>fg", "<cmd>FzfLua git_files<cr>", desc = "Find Files (git-files)" },
  { "<leader>fr", "<cmd>FzfLua oldfiles<cr>", desc = "Recent" },
  { "<leader>fR", "<md>lua require('fzf-lua').oldfiles({cwd_only=true})<cr>", desc = "Recent (cwd)" },
  { "<leader>ft", "<cmd>FzfLua tabs<cr>", desc = "Tabs" },
  -- git
  { "<leader>gc", "<cmd>FzfLua git_commits<CR>", desc = "Commits" },
  { "<leader>gS", "<cmd>FzfLua git_status<CR>", desc = "Status" },
  -- search
  { '<leader>s"', "<cmd>FzfLua registers<cr>", desc = "Registers" },
  { "<leader>sa", "<cmd>FzfLua autocmds<cr>", desc = "Auto Commands" },
  { "<leader>sb", "<cmd>FzfLua grep_curbuf<cr>", desc = "Buffer" },
  { "<leader>sc", "<cmd>FzfLua command_history<cr>", desc = "Command History" },
  { "<leader>sC", "<cmd>FzfLua commands<cr>", desc = "Commands" },
  { "<leader>sd", "<cmd>FzfLua diagnostics_document<cr>", desc = "Document Diagnostics" },
  { "<leader>sD", "<cmd>FzfLua diagnostics_workspace<cr>", desc = "Workspace Diagnostics" },
  { "<leader>sg", "<cmd>FzfLua live_grep<cr>", desc = "Grep (cwd)" },
  { "<leader>sh", "<cmd>FzfLua help_tags<cr>", desc = "Help Pages" },
  { "<leader>sH", "<cmd>FzfLua highlights<cr>", desc = "Search Highlight Groups" },
  { "<leader>sj", "<cmd>FzfLua jumps<cr>", desc = "Jumplist" },
  { "<leader>sk", "<cmd>FzfLua keymaps<cr>", desc = "Key Maps" },
  { "<leader>sl", "<cmd>FzfLua loclist<cr>", desc = "Location List" },
  { "<leader>sM", "<cmd>FzfLua man_pages<cr>", desc = "Man Pages" },
  { "<leader>sm", "<cmd>FzfLua marks<cr>", desc = "Jump to Mark" },
  { "<leader>sR", "<cmd>FzfLua resume<cr>", desc = "Resume" },
  { "<leader>sq", "<cmd>FzfLua quickfix<cr>", desc = "Quickfix List" },
  { "<leader>sw", "<cmd>FzfLua grep_cword<cr>", desc = "Word (cwd)" },
  { "<leader>sw", "<cmd>FzfLua grep_visual<cr>", mode = "v", desc = "Selection (cwd)" },
  { "<leader>uC", "<cmd>FzfLua colorschemes<cr>", desc = "Colorscheme with Preview" },
  {
    "<leader>ss",
    function()
      require("fzf-lua").lsp_document_symbols()
    end,
    desc = "Goto Symbol",
  },
  {
    "<leader>sS",
    function()
      require("fzf-lua").lsp_live_workspace_symbols()
    end,
    desc = "Goto Symbol (Workspace)",
  },
}

return M
