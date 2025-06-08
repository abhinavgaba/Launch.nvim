--- Show a popup window with the given title and the given table of strings as
--- its body.
--- @param title string
--- @param body table
local function showPopup(title, body)
  local NuiPopup = require "nui.popup"
  local popupHeight = vim.fn.max { #body, 1 }
  local popupWidth = string.len(title) + 2
  for _, str in pairs(body) do
    popupWidth = vim.fn.max { popupWidth, string.len(str) }
  end

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
      width = popupWidth,
      height = popupHeight,
    },
  }
  -- mount/open the component
  popup:mount()

  -- set content
  vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, body)

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

local ffi = require "ffi"

ffi.cdef [[
  const char* getAsHex(const char*);
  const char* getAsDec(const char*);
]]
local configPath = vim.fn.stdpath('config')
print(vim.inspect(configPath))
local lib = ffi.load(configPath .. "/lua/user/custom/c_utils.so")

-- To test:
-- 0xff00ffffff9e0140
-- 18374967954641912128

--- Return the current word under the cursor in hex format.
--- @return string
local function getCwordInHex()
  local curword = vim.fn.expand "<cword>"
  if curword == "" then
    print "No word under the cursor"
  end
  local ret = lib.getAsHex(curword)
  local retCast = ffi.string(ret)
  -- print(vim.inspect(retCast))
  return retCast
end

--- Convert the word under the cursor into hex, and show it in
--- a popup
local function showCwordInHexInPopup()
  local curWordInHex = getCwordInHex()
  showPopup("In Hex", { curWordInHex })
end

--- Convert the word under the cursor into decimal, and show it in
--- a popup
local function showCwordInDecInPopup()
  -- local curWordInHex = getCwordInHex()
  -- local curWordInDec = vim.fn.printf("%d", curWordInHex)
  local curword = vim.fn.expand "<cword>"
  if curword == "" then
    print "No word under the cursor"
  end
  local ret = lib.getAsDec(curword)
  local retCast = ffi.string(ret)
  -- print(vim.inspect(retCast))
  showPopup("In Dec", { retCast })
end

--- Extracted from clang's libomptarget.h header file.
local MapTypes = {
  TO = 0x001,
  FROM = 0x002,
  ALWAYS = 0x004,
  DELETE = 0x008,
  PTR_AND_OBJ = 0x010,
  TARGET_PARAM = 0x020,
  RETURN_PARAM = 0x040,
  PRIVATE = 0x080,
  LITERAL = 0x100,
  IMPLICIT = 0x200,
  CLOSE = 0x400,
  PRESENT = 0x1000,
  OMPX_HOLD = 0x2000,
  NON_CONTIG = 0x100000000000,
}
-- 0x1fff000000000000,
-- 0x1fff000000001003,
-- 0x0011000000011011,

local function getOpenMPMapTypeFromHex()
  local curWordInHex = getCwordInHex()
  curWordInHex = vim.fn.printf("0x%016x", curWordInHex)

  -- 64 bit bitwise operations are a bit tricky in lua. So we first intentionally
  -- break-off the member-of fields to reduce the size of the integer to work with.
  local memberOfBits = string.sub(curWordInHex, 0, 6)
  local flagBits = "0x" .. string.sub(curWordInHex, 7)
  local flagBitsInInt = tonumber(flagBits, 10)

  local mapTypeStrings = {}
  if memberOfBits ~= "0x0000" then
    local memberOfString = vim.fn.printf("%s000000000000 = MEMBER_OF(%d)", memberOfBits, memberOfBits)
    table.insert(mapTypeStrings, memberOfString)
  end

  for name, val in pairs(MapTypes) do
    if flagBitsInInt == 0 then
      break
    end

    local bitwiseAnd = vim.fn["and"](flagBitsInInt, val)
    if bitwiseAnd ~= 0 then
      local mapTypeString = vim.fn.printf("0x%-16x = %s", val, name)
      table.insert(mapTypeStrings, mapTypeString)
      local invertedVal = vim.fn.invert(val)
      flagBitsInInt = vim.fn["and"](flagBitsInInt, invertedVal)
    end
  end

  if flagBitsInInt ~= 0 then
    table.insert(mapTypeStrings, vim.fn.printf("0x%-16x = UNKNOWN", flagBitsInInt))
  end

  return curWordInHex, mapTypeStrings
end

local function showOpenMPMapTypesInPopup()
  local mapType, mapTypeStrings = getOpenMPMapTypeFromHex()
  showPopup("MAP_TYPE:" .. mapType, mapTypeStrings)
end

vim.keymap.set("n", "<leader>dh", showCwordInHexInPopup, { desc = "Display current word in Hex" })
vim.keymap.set("n", "<leader>dd", showCwordInDecInPopup, { desc = "Display current word in Dec" })
vim.keymap.set("n", "<leader>dm", showOpenMPMapTypesInPopup, { desc = "Display map-types for the current word" })
