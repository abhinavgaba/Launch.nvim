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
    vim.highlight.on_yank { higroup = "Visual", timeout = 40 }
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
