-- require "user.profiler-setup"
require "user.launch"
require "user.options"
-- Set machine-specific options, if available
pcall(require, "user.options-local")
require "user.keymaps"
require "user.autocmds"
require "user.lazy-utils"
require "user.custom.functions"
require "user.neovide-options"
spec "user.snacks"
spec "user.colorscheme"
spec "user.devicons"
spec "user.treesitter"
spec "user.mason"
spec "user.auto-session"
spec "user.lsp_signature"
spec "user.lspconfig"
spec "user.none-ls"
spec "user.mason-null-ls"
spec "user.nvim-dap"
spec "user.overseer"
spec "user.blink"
spec "user.extras.copilot"
spec "user.extras.render-markdown"
spec "user.extras.blink-cmp-copilot"
spec "user.extras.avante"
spec "user.fzf-lua"
spec "user.illuminate"
spec "user.diffview"
spec "user.blame"
spec "user.gitsigns"
spec "user.fugitive"
spec "user.whichkey"
spec "user.nvimtree"
spec "user.comment"
spec "user.lualine"
spec "user.dropbar"
spec "user.harpoon"
spec "user.flash"
spec "user.autopairs"
spec "user.vim-better-whitespace"
spec "user.neogit"
spec "user.indentline"
spec "user.toggleterm"
spec "user.trouble"
spec "user.rainbow-delimiters"
spec "user.undotree"
spec "user.noice"
spec "user.todo-comments"
spec "user.mini-ai"
spec "user.mini-align"
spec "user.extras.treesj"
spec "user.extras.bqf"
spec "user.extras.dial"
spec "user.extras.dressing"
spec "user.extras.eyeliner"
spec "user.extras.modicator"
spec "user.extras.neotab"
spec "user.extras.tabby"
spec "user.extras.ufo"
spec "user.extras.beacon"
spec "user.extras.actions-preview"
spec "user.extras.goto-preview"
spec "user.extras.treesitter-context"
spec "user.extras.context-vt"
spec "user.extras.treewalker"
spec "user.extras.tiny-inline-diagnostic"
spec "user.extras.mini-animate"
spec "user.extras.symbol-usage"
spec "user.extras.advanced-git-search"
require "user.lazy"
-- Disabled
-- spec "user.alpha" -- Use snacks.dashboard instead
-- spec "user.telescope"
-- spec "user.telescope-tabs"
-- spec "user.extras.fidget" -- noice does this too
-- spec "user.schemastore"
-- spec "user.cmp" -- use blink instead
-- spec "user.project"
-- spec "user.navic" -- dropbar is better
-- spec "user.extras.navbuddy"
-- spec "user.extras.neoscroll" -- Use snacks.scroll instead
-- spec "user.extras.neodev"
-- spec "user.extras.oil" --nvim-tree is sufficient for most cases
-- spec "user.feline" -- Use lualine instead
-- spec "user.extras.mini-diff"
-- spec "user.extras.codecompanion"
-- spec "user.neotest"
