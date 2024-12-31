-- Some lazy.nvim specific functions from LazyVim to help launch
-- autocmds/schedule tasks based on whether a plugin has been loded.

local M = {}

--- Check if the plugin already been loaded.
--- @param name string
function M.is_loaded(name)
  local Config = require "lazy.core.config"
  return Config.plugins[name] and Config.plugins[name]._.loaded
end

--- Launch the given callback once the plugin "name" has been loaded.
--- Or run it immediately if it's already been loaded.
---@param name string
---@param fn fun(name:string)
function M.on_load(name, fn)
  if M.is_loaded(name) then
    fn(name)
    return
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(event)
      if event.data == name then
        fn(name)
        return true
      end
    end,
  })
end

return M
