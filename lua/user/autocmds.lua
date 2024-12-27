vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = {
    "netrw",
    "Jaq",
    "qf",
    "git",
    "help",
    "man",
    "lspinfo",
    "oil",
    "spectre_panel",
    "lir",
    "DressingSelect",
    "tsplayground",
    "undotree",
    "",
  },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})

-- Set column column width to 81 for c/cpp/ to git commit messages
-- vim.api.nvim_create_autocmd({ "FileType" }, {
--   pattern = { "gitcommit", "c", "cpp", "NeogitCommitMessage" },
--   callback = function()
--   vim.cmd [[ setlocal colorcolumn="81" ]]
--     end,
--   })

vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
  callback = function()
    vim.cmd "quit"
  end,
})

-- Disable this because this causes auto-switching to the last tab.
-- vim.api.nvim_create_autocmd({ "VimResized" }, {
--   callback = function()
--     vim.cmd "tabdo wincmd ="
--   end,
-- })

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd "checktime"
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 100 }
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown", "NeogitCommitMessage" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

vim.api.nvim_create_autocmd({ "CursorHold" }, {
  callback = function()
    local status_ok, luasnip = pcall(require, "luasnip")
    if not status_ok then
      return
    end
    if luasnip.expand_or_jumpable() then
      -- ask maintainer for option to make this silent
      -- luasnip.unlink_current()
      vim.cmd [[silent! lua require("luasnip").unlink_current()]]
    end
  end,
})

-- Enable auto-snapshots of lazy.lock files to allow restoring of plugins to
-- a previous state, if an update breaks it.
local config = vim.fn.stdpath "config"
local SNAPSHOTS_DIR = string.format("%s/lockfile_snapshots/", config)

vim.api.nvim_create_user_command(
  'BrowseSnapshots',
  'edit ' .. SNAPSHOTS_DIR,
  {}
)

vim.api.nvim_create_autocmd("User", {
  pattern = "LazySync",
  callback = function()
    local uv = vim.loop

    local NUM_BACKUPS = 50
    print "here"

    -- create if not existing
    if not uv.fs_stat(SNAPSHOTS_DIR) then
      uv.fs_mkdir(SNAPSHOTS_DIR, 448)
    end

    local lockfile = require("lazy.core.config").options.lockfile
    if uv.fs_stat(lockfile) then
      -- create "%Y%m%d_%H:%M:%s_lazy-lock.json" in lockfile folder
      local filename = string.format("%s_lazy-lock.json", os.date "%Y%m%d_%H:%M:%S")
      local backup_lock = string.format("%s/%s", SNAPSHOTS_DIR, filename)
      local success = uv.fs_copyfile(lockfile, backup_lock)
      if success then
        -- clean up backups in excess of `num_backups`
        local iter_dir = uv.fs_scandir(SNAPSHOTS_DIR)
        if iter_dir then
          local suffix = "lazy-lock.json"
          local backups = {}
          while true do
            local name = uv.fs_scandir_next(iter_dir)
            -- make sure we are deleting lockfiles
            if name and name:sub(- #suffix, -1) == suffix then
              table.insert(backups, string.format("%s/%s", SNAPSHOTS_DIR, name))
            end
            if name == nil then
              break
            end
          end
          if not vim.tbl_isempty(backups) and #backups > NUM_BACKUPS then
            -- remove the lockfiles
            for _ = 1, #backups - NUM_BACKUPS do
              uv.fs_unlink(table.remove(backups, 1))
            end
          end
        end
      end
      vim.notify(string.format("Backed up %s", filename), vim.log.levels.INFO, { title = "lazy.nvim" })
    end
  end,
})


-- Autocmds to detach clangd when a git diff window is open.
-- Table to track which buffers have had clangd detached
local clangd_detached_buffers = {}

-- Helper function to check if a buffer's name starts with specific prefixes
local function is_special_buffer(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  return filename:match("^fugitive:") or filename:match("^diffview:") or filename:match("^gitsigns:")
end

-- Helper function to safely get buffer from a window
local function safe_get_buf_from_win(win)
  if vim.api.nvim_win_is_valid(win) then
    local success, buf = pcall(vim.api.nvim_win_get_buf, win)
    if success then
      return buf
    end
  end
  return nil
end

-- Get a human-readable name for a buffer
local function get_buffer_name(bufnr)
  return vim.api.nvim_buf_get_name(bufnr) or "<unnamed>"
end

-- Check if any visible window still has a special buffer
local function has_visible_special_buffers()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = safe_get_buf_from_win(win)
    if buf and is_special_buffer(buf) then
      return true
    end
  end
  return false
end

-- Detach clangd from a buffer
local function detach_clangd_from_buffer(bufnr)
  if not clangd_detached_buffers[bufnr] then
    local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
    for _, client in ipairs(clients) do
      if client.name == "clangd" then
        vim.lsp.buf_detach_client(bufnr, client.id)
        clangd_detached_buffers[bufnr] = true
        vim.notify(
          string.format("Detached clangd for buffer %d (%s)", bufnr, get_buffer_name(bufnr)),
          vim.log.levels.INFO
        )
      end
    end
  end
end

-- Reattach clangd to a buffer
local function reattach_clangd_to_buffer(bufnr)
  if clangd_detached_buffers[bufnr] then
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
      if client.name == "clangd" then
        vim.lsp.buf_attach_client(bufnr, client.id)
        clangd_detached_buffers[bufnr] = nil
        vim.notify(
          string.format("Reattached clangd for buffer %d (%s)", bufnr, get_buffer_name(bufnr)),
          vim.log.levels.INFO
        )
      end
    end
  end
end

-- Autocmd to reattach clangd when a special buffer is closed
vim.api.nvim_create_autocmd("BufWinLeave", {
  callback = function(args)
    local bufnr = args.buf
    if is_special_buffer(bufnr) then
      vim.defer_fn(function()
        if not has_visible_special_buffers() then
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            local buf = safe_get_buf_from_win(win)
            if buf then
              reattach_clangd_to_buffer(buf)
            end
          end
        end
      end, 50) -- 50ms delay to allow state to settle
    end
  end,
})

-- Autocmd to handle entering windows with special or non-special buffers
vim.api.nvim_create_autocmd("BufWinEnter", {
  callback = function(args)
    local bufnr = args.buf
    if is_special_buffer(bufnr) then
      -- Detach clangd from all visible non-special buffers
      for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = safe_get_buf_from_win(win)
        if buf then
          detach_clangd_from_buffer(buf)
        end
      end
    else
      -- If no special buffers are visible, reattach clangd to this buffer if it was detached
      if not has_visible_special_buffers() then
        reattach_clangd_to_buffer(bufnr)
      end
    end
  end,
})

-- Autocmd to handle late attachment of clangd
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "clangd" then
      -- Check if clangd should be detached for this buffer
      if has_visible_special_buffers() then
        detach_clangd_from_buffer(bufnr)
        vim.notify(
          string.format("Detached clangd from buffer %d (%s) after late attach", bufnr, get_buffer_name(bufnr)),
          vim.log.levels.INFO
        )
      end
    end
  end,
})

