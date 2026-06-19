local M = {
  "Bekaboo/dropbar.nvim",
  event = "BufReadPost",
  -- optional, but required for fuzzy finder support
  dependencies = {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },
}

-- Number of trailing path components (filename + parent dirs) to keep before
-- collapsing the rest behind an ellipsis when the path would overflow the window.
local KEEP_TRAILING = 2

local vcs = require "user.custom.vcs-bufname"
local parse_vcs_bufname = vcs.parse
local short_rev = vcs.short_rev

-- Build a custom source that shows just "<filename> @ <rev>" for diff buffers.
local function vcs_source(filepath, rev)
  return {
    get_symbols = function(buf, win, _)
      local bar = require "dropbar.bar"
      local icons = require("dropbar.configs").opts.icons
      local fname = vim.fs.basename(filepath)
      local file_icon, file_icon_hl = require("dropbar.configs").eval(icons.kinds.file_icon, filepath)
      return {
        bar.dropbar_symbol_t:new {
          buf = buf,
          win = win,
          icon = file_icon,
          icon_hl = file_icon_hl,
          name = fname,
          name_hl = "DropBarKindFile",
        },
        bar.dropbar_symbol_t:new {
          buf = buf,
          win = win,
          name = "@ " .. short_rev(rev),
          name_hl = "Comment",
          on_click = false,
        },
      }
    end,
  }
end

-- Wrap the built-in path source so that, when the rendered path would overflow
-- the window, we keep the filename plus KEEP_TRAILING parent dirs and replace the
-- leading dirs with a single ellipsis symbol (cleaner than dropbar's per-char trim).
local function truncated_path_source()
  return {
    get_symbols = function(buf, win, cursor)
      local path = require "dropbar.sources.path"
      local symbols = path.get_symbols(buf, win, cursor)
      if #symbols <= KEEP_TRAILING + 1 then
        return symbols
      end

      -- Sum widths the same way dropbar's truncate does, plus separators.
      local sep_w = vim.fn.strdisplaywidth(require("dropbar.configs").opts.icons.ui.bar.separator)
      local total = 0
      for _, s in ipairs(symbols) do
        total = total + s:displaywidth() + sep_w
      end
      -- Leave some slack for padding / other UI; only act when clearly overflowing.
      if total <= vim.api.nvim_win_get_width(win) - 4 then
        return symbols
      end

      local bar = require "dropbar.bar"
      local ellipsis = require("dropbar.configs").opts.icons.ui.bar.extends
      local kept = {
        bar.dropbar_symbol_t:new {
          buf = buf,
          win = win,
          name = ellipsis,
          name_hl = "WinBarIconUIExtends",
          on_click = false,
        },
      }
      for i = #symbols - KEEP_TRAILING + 1, #symbols do
        table.insert(kept, symbols[i])
      end
      return kept
    end,
  }
end

-- Global on/off flag, gated into bar.enable below. dropbar re-attaches the
-- winbar on every BufEnter/WinEnter, so a plain `set winbar=` won't stick;
-- flipping this flag (and refreshing windows) is the durable way to toggle it.
vim.g.dropbar_enabled = vim.g.dropbar_enabled ~= false

-- Re-evaluate the winbar on every window in the current tab so a toggle takes
-- effect immediately rather than on the next buffer/window switch.
local function refresh_dropbar()
  local utils = require "dropbar.utils"
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_is_valid(win) then
      if vim.g.dropbar_enabled then
        utils.bar.attach(vim.api.nvim_win_get_buf(win), win)
      else
        vim.wo[win][0].winbar = ""
      end
    end
  end
end

function M.config()
  local dropbar_api = require "dropbar.api"
  vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
  vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
  vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
  -- Use Snacks.toggle so the on/off state shows up in which-key.
  Snacks.toggle
    .new({
      name = "Dropbar (winbar)",
      get = function()
        return vim.g.dropbar_enabled
      end,
      set = function(state)
        vim.g.dropbar_enabled = state
        refresh_dropbar()
      end,
    })
    :map "<Leader>tb"

  -- Default enable predicate from dropbar.configs, evaluated lazily so we don't
  -- duplicate its logic; we only add the global flag gate in front of it.
  local default_enable = require("dropbar.configs").opts.bar.enable

  require("dropbar").setup {
    bar = {
      enable = function(buf, win, info)
        if not vim.g.dropbar_enabled then
          return false
        end
        return require("dropbar.configs").eval(default_enable, buf, win, info)
      end,
      sources = function(buf, win)
        local sources = require "dropbar.sources"
        local utils = require "dropbar.utils"

        -- Diff / VCS virtual buffers: show "filename @ rev" followed by code
        -- breadcrumbs. LSP doesn't attach to these virtual buffers, but plugins
        -- like CodeDiff start a treesitter parser, so the treesitter source works.
        local vcs_file, vcs_rev = parse_vcs_bufname(vim.api.nvim_buf_get_name(buf))
        if vcs_file then
          return { vcs_source(vcs_file, vcs_rev), sources.treesitter }
        end

        if vim.bo[buf].ft == "markdown" then
          return { truncated_path_source(), sources.markdown }
        end
        if vim.bo[buf].buftype == "terminal" then
          return { sources.terminal }
        end
        return {
          truncated_path_source(),
          utils.source.fallback { sources.lsp, sources.treesitter },
        }
      end,
    },
  }
end

return M
