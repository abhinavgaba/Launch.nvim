local LazyUtils = require "user.lazy-utils"

local function set_keymaps()
  local keymap = vim.keymap.set
  local opts = { noremap = true, silent = true }
  local has_snacks = LazyUtils.has "snacks.nvim"

-- stylua: ignore start
  -- keymap("n", "<Space>", "", opts)
  keymap("n", "<C-i>", "<C-i>", opts)

  keymap("n", "n", "nzz", opts)
  keymap("n", "N", "Nzz", opts)
  keymap("n", "*", "*zz", opts)
  keymap("n", "#", "#zz", opts)
  keymap("n", "g*", "g*zz", opts)
  keymap("n", "g#", "g#zz", opts)

  -- Stay in indent mode
  keymap("v", "<", "<gv", opts)
  keymap("v", ">", ">gv", opts)

  keymap("x", "p", [["_dP]])

  vim.cmd [[:amenu 10.100 mousemenu.Goto\ Definition <cmd>lua vim.lsp.buf.definition()<CR>]]
  vim.cmd [[:amenu 10.110 mousemenu.References <cmd>lua vim.lsp.buf.references()<CR>]]
  -- vim.cmd [[:amenu 10.120 mousemenu.-sep- *]]

  vim.keymap.set("n", "<RightMouse>", "<cmd>:popup mousemenu<CR>")
  -- vim.keymap.set("n", "<Tab>", "<cmd>:popup mousemenu<CR>")

  -- more good
  keymap({ "n", "o", "x" }, "<s-h>", "^", opts)
  keymap({ "n", "o", "x" }, "<s-l>", "g_", opts)

  -- tailwind bearable to work with
  keymap({ "n", "x" }, "j", "gj", opts)
  keymap({ "n", "x" }, "k", "gk", opts)

  vim.api.nvim_set_keymap("t", "<C-;>", "<C-\\><C-n>", opts)

  -- run "bc" calculator on the line's text
  vim.cmd [[ map <leader>bc yypkA =<Esc>jOscale=2<Esc>:.,+1!bc<CR>kJ ]]

  -- better up/down
  keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
  keymap({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
  keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
  keymap({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

  -- Move to window using the <ctrl> hjkl keys
  keymap("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
  keymap("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
  keymap("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
  keymap("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

  -- Resize window using <ctrl> arrow keys
  keymap("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
  keymap("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
  keymap("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
  keymap("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

  -- Move Lines
  keymap("n", "<A-J>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
  keymap("n", "<A-K>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
  keymap("i", "<A-J>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
  keymap("i", "<A-K>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
  keymap("v", "<A-J>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
  keymap("v", "<A-K>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

  -- buffers
  keymap("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
  keymap("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
  keymap("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
  keymap("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

  if has_snacks then
    keymap("n", "<leader>bd", function()
      Snacks.bufdelete()
    end, { desc = "Delete Buffer" })
    keymap("n", "<leader>bo", function()
      Snacks.bufdelete.other()
    end, { desc = "Delete Other Buffers" })
  end

  keymap("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

  -- Clear search, diff update and redraw
  -- taken from runtime/lua/_editor.lua
  keymap(
    "n",
    "<leader>ur",
    "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    { desc = "Redraw / Clear hlsearch / Diff Update" }
  )

  -- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
  keymap("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
  keymap("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  keymap("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
  keymap("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
  keymap("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
  keymap("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

  -- Add undo break-points
  keymap("i", ",", ",<c-g>u")
  keymap("i", ".", ".<c-g>u")
  keymap("i", ";", ";<c-g>u")

  -- save file
  keymap({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

  --keywordprg
  keymap("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

  -- commenting
  -- keymap("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
  -- keymap("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

  keymap("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
  keymap("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- lazygit
if vim.fn.executable("lazygit") == 1 and has_snacks then
  -- map("n", "<leader>gg", function() Snacks.lazygit( { cwd = LazyVim.root.git() }) end, { desc = "Lazygit (Root Dir)" })
  keymap("n", "<leader>gG", function() Snacks.lazygit() end, { desc = "Lazygit (cwd)" })
  keymap("n", "<leader>gf", function() Snacks.lazygit.log_file() end, { desc = "Lazygit Current File History" })
  -- map("n", "<leader>gl", function() Snacks.lazygit.log({ cwd = LazyVim.root.git() }) end, { desc = "Lazygit Log" })
  map("n", "<leader>gL", function() Snacks.lazygit.log() end, { desc = "Lazygit Log (cwd)" })
end

if has_snacks then
keymap("n", "<leader>gw", function() Snacks.git.blame_line() end, { desc = "Git Blame Line" })
keymap({ "n", "x" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Git Browse (open)" })
keymap({"n", "x" }, "<leader>gY", function()
  Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end, notify = false })
end, { desc = "Git Browse (copy)" })
  end

-- quit
keymap("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit All" })
keymap("n", "<leader>q", "<cmd>confirm q<cr>", {desc = "Quit" })

-- Terminal Mappings
  if has_snacks then
keymap("n", "<leader>tt", function() Snacks.terminal() end, { desc = "Terminal (cwd)" })
keymap("t", "<leader>tt", "<cmd>close<cr>", { desc = "which_key_ignore" })
  end

-- windows
keymap("n", "<leader>w", "<c-w>", { desc = "Windows", remap = true })
keymap("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
keymap("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
keymap("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })
if has_snacks then
  Snacks.toggle.zoom():map("<leader>wm"):map("<leader>tZ")
  Snacks.toggle.zen():map("<leader>tz")
end

if LazyUtils.has("auto-session") then
  keymap("n", "<leader>wr", "<cmd>SessionRestore<CR>", { desc = "Restore session for cwd" }) -- restore last workspace session for current directory
  keymap("n", "<leader>ws", "<cmd>SessionSave<CR>", { desc = "Save session for auto session root dir" }) -- save workspace session for current working directory
end

-- tabs
keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap("n", "<leader><tab>k", "<cmd>-tabmove<cr>", { desc = "Move Tab Left" })
keymap("n", "<leader><tab>j", "<cmd>+tabmove<cr>", { desc = "Move Tab Right" })
keymap("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
keymap("n", "<leader><tab>h", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
end

-- These need to be set before launching lazy
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set keymaps as a VeryLazy event.
LazyUtils.on_very_lazy(set_keymaps)
