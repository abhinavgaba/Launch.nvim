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

  -- Use "jk" as esc in insert/visual/terminal modes.
  keymap({ "i", "v", "t" }, "jk", "<esc>", opts)

  -- Use alt-hjkl in insert mode to move around
  keymap("i", "<M-h>", "<left>", opts)
  keymap("i", "<M-j>", "<down>", opts)
  keymap("i", "<M-k>", "<up>", opts)
  keymap("i", "<M-l>", "<right>", opts)

  vim.api.nvim_set_keymap("t", "<C-;>", "<C-\\><C-n>", opts)

  -- run "bc" calculator on the line's text
  keymap("n", "<leader>bc", "yypkA =<Esc>jOscale=2<Esc>:.,+1!bc<CR>kJ", {desc = "Run BC on the line"})

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
  keymap("n", "<C-M-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
  keymap("n", "<C-M-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
  keymap("i", "<C-M-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
  keymap("i", "<C-M-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
  keymap("v", "<C-M-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
  keymap("v", "<C-M-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

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

  -- Close all git diff views (DiffView, CodeDiff, Gitsigns, Fugitive)
  keymap("n", "<leader>gQ", function()
    local closed_something = false

    -- Close DiffView
    local ok = pcall(vim.cmd, "DiffviewClose")
    if ok then
      closed_something = true
    end

    -- Handle CodeDiff: close it but keep the file open
    local ok_codediff, session_mod = pcall(require, "codediff.ui.lifecycle.session")
    if ok_codediff then
      local tabpage = vim.api.nvim_get_current_tabpage()
      local session = session_mod.get_active_diffs()[tabpage]
      if session then
        -- Get the file path we're viewing (prefer modified path, which is usually the working file)
        local file_path = session.modified_path
        if file_path and session.modified_revision ~= "WORKING" then
          file_path = session.original_path
        end

        -- Convert to absolute path
        if file_path and session.git_root then
          file_path = vim.fn.fnamemodify(session.git_root .. "/" .. file_path, ":p")

          -- Check if this file is already open in another tab
          local found_tab = nil
          for _, tp in ipairs(vim.api.nvim_list_tabpages()) do
            if tp ~= tabpage then
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tp)) do
                local buf = vim.api.nvim_win_get_buf(win)
                local bufname = vim.api.nvim_buf_get_name(buf)
                if bufname == file_path then
                  found_tab = tp
                  break
                end
              end
            end
            if found_tab then break end
          end

          -- Close current CodeDiff tab
          vim.cmd("tabclose")

          if found_tab then
            -- Switch to the tab with the file
            vim.api.nvim_set_current_tabpage(found_tab)
          else
            -- Open the file in current tab
            vim.cmd("edit " .. vim.fn.fnameescape(file_path))
          end
        else
          -- No file path, just close the tab
          vim.cmd("tabclose")
        end

        closed_something = true
        return
      end
    end

    -- Close Gitsigns and Fugitive windows
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      local bufname = vim.api.nvim_buf_get_name(buf)
      if bufname:match("^gitsigns:") or bufname:match("^fugitive://") then
        vim.api.nvim_win_close(win, false)
        closed_something = true
      end
    end

    if not closed_something then
      vim.notify("No git diff views open", vim.log.levels.INFO)
    end
  end, { desc = "Close All Git Diffs" })

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
