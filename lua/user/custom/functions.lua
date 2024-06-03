local function showPopup(title, body)
  local NuiPopup = require "nui.popup"

  local popup = NuiPopup {
    enter = false,
    focusable = false,
    -- zindex = 50,
    border = {
      style = "rounded",
      text = {
        top = title,
      },
    },
    buf_options = {
      modifiable = true,
      readonly = false,
    },
    win_options = {
      winblend = 10,
      winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
    },
    relative = "cursor",
    position = "2",
    size = {
      width = "20",
      height = "1",
    },
  }
  -- mount/open the component
  popup:mount()

  -- set content
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, { body })

  vim.api.nvim_create_autocmd({ "CursorMoved" }, {
    desc = "Clear Nui Popup",
    callback = function()
      if popup and popup.winid then
        vim.api.nvim_win_close(popup.winid, true)
      end
      popup:unmount()
    end,
    once = true,
  })
end

local function getCwordInHex()
  local curword = vim.fn.expand "<cword>"
  print("cword is ", curword)
  if curword == "" then
    error "No word under the cursor"
  end
  local ret = vim.fn.printf("0x%x", curword)
  return ret
end

-- Convert the word under the cursor into hex, and show it in
-- a popup
local function showCwordInHexInPopup()
  local curWordInHex = getCwordInHex()
  showPopup("In Hex", curWordInHex)
end

vim.keymap.set("n", "<leader>hx", showCwordInHexInPopup, { desc = "Show current word in Hex" })
