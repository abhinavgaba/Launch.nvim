local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/neodev.nvim",
    },
  },
}

--- @param bufnr integer
local function lsp_keymaps(bufnr)
  -- Check if the keymaps are already set for this buffer
  if vim.b[bufnr].diagnostic_keymaps_set then
    return
  end

  -- Mark diagnostics keymaps as set for this buffer
  vim.b[bufnr].diagnostic_keymaps_set = true

    -- Set keymaps for navigating diagnostics
  local opts_with_desc = function(desc)
    return {noremap = true, buffer = bufnr, silent = true, desc = desc}
  end

  local keymap = vim.keymap.set
  local lazy_utils = require("user.lazy-utils")
  local tid_present = lazy_utils.has("tiny-inline-diagnostic.nvim")

  keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts_with_desc("Declaration (LSP)"))
  keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts_with_desc("definition (LSP)"))
  keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts_with_desc("Hover Info (LSP)"))
  keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts_with_desc("Implementation (LSP)"))
  keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts_with_desc("References (LSP)"))

  -- Use tiny-inline-diagnostic shortcuts to show diagnostics floats, if available
  local diagnostic_goto_fn = function(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
      go { severity = severity, float = not tid_present}
    end
  end

  keymap("n", "<leader>lj", diagnostic_goto_fn(true), opts_with_desc("Next Diagnostic"))
  keymap("n", "<leader>lk", diagnostic_goto_fn(false), opts_with_desc("Prev Diagnostic"))
  keymap("n", "]d", diagnostic_goto_fn(true), opts_with_desc("Next Diagnostic"))
  keymap("n", "[d", diagnostic_goto_fn(false), opts_with_desc("Prev Diagnostic"))
  keymap("n", "]e", diagnostic_goto_fn(true, "ERROR"), opts_with_desc("Next Error"))
  keymap("n", "[e", diagnostic_goto_fn(false, "ERROR"), opts_with_desc("Prev Error"))
  keymap("n", "]w", diagnostic_goto_fn(true, "WARN"), opts_with_desc("Next Warning"))
  keymap("n", "[w", diagnostic_goto_fn(false, "WARN"), opts_with_desc("Prev Warning"))

  if tid_present then
    keymap("n", "<leader>lt", "<cmd>lua require('tiny-inline-diagnostic').toggle()<cr>", opts_with_desc("Toggle Floating Diagnostics"))
  end

  if lazy_utils.has "which-key.nvim" then
    lazy_utils.on_load("which-key.nvim", function()
      vim.schedule(function()
        local wk = require "which-key"
        local icons = require "user.icons"
        spec = {
          mode = { "n", "v" },
          { "<leader>l", group = "lsp", icon = { icon = icons.ui.Code, color = "blue" } },
        }
        wk.add(spec)
      end)
    end)
  end

  keymap("n", "<leader>lA", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts_with_desc("Code Action (without Preview)"))
  keymap("n",
    "<leader>lf",
    "<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
    opts_with_desc("Format")
  )

  local has_snacks = require("user.lazy-utils").has "snacks.nvim"
  if has_snacks then
    Snacks.toggle.inlay_hints():map("<leader>lh"):map("<leader>th")
    Snacks.toggle.diagnostics():map("<leader>ld"):map("<leader>td")
  else
    keymap("n", "<leader>lh", "<cmd>lua require('user.lspconfig').toggle_inlay_hints()<cr>", opts_with_desc("Inlay Hints"))
    keymap("n", "<leader>ld", "<cmd>lua require('user.lspconfig').toggle_diagnostics()<cr>", opts_with_desc("Diagnostics"))
  end
  keymap("n", "<leader>li", "<cmd>LspInfo<cr>", opts_with_desc("Info"))
  keymap("n", "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", opts_with_desc("CodeLens Action"))
  keymap("n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", opts_with_desc("Quickfix"))
  keymap("n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts_with_desc("Rename"))
  -- Visual mode shortcuts
  keymap("v", "<leader>lA", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts_with_desc("Code Action (without Preview)"))
  keymap("v", "<leader>lf", "<cmd>lua vim.lsp.buf.format({async=true})<cr>", opts_with_desc("Code Format"))

  local actions_preview_present = require("user.lazy-utils").has("actions-preview.nvim")
  if actions_preview_present then
    keymap({"n", "v"}, "<leader>la", function() require("actions-preview").code_actions() end, opts_with_desc("Code Action (w/ Preview)"))
  end
end

--- @type vim.lsp.client.on_attach_cb
M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)

  -- if client.supports_method "textDocument/inlayHint" then
  --   vim.lsp.inlay_hint.enable(true, { bufnr })
  -- end

  -- Use lsp-signature for showing function signatures when typing
  if not require("user.lazy-utils").has "lsp_signature.nvim" then
    return
  end

  local lsp_signature = require("lsp_signature")
  -- Disable lsp_signature for specific lsps
  if vim.tbl_contains({ "null-ls" }, client.name) then -- blacklist lsp
    return
  end

  local icons = require "user.icons"
  local signature_config = {
    -- Setup options for lsp_signature
    hint_prefix = icons.misc.Dog .. " ",
    max_height = 30,
  }
  lsp_signature.on_attach(signature_config, bufnr)
end

function M.common_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  -- Setup required for ufo
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return capabilities
end

M.toggle_inlay_hints = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr }, { bufnr })
end

vim.g.diagnostics_visible = true
function M.toggle_diagnostics()
  if vim.g.diagnostics_visible then
    vim.g.diagnostics_visible = false
    vim.diagnostic.enable(false)
  else
    vim.g.diagnostics_visible = true
    vim.diagnostic.enable()
  end
end

function M.config()
  local lspconfig = require "lspconfig"
  local icons = require "user.icons"

  local servers = {
    "lua_ls",
    "clangd",
    "fortls",
    "bashls",
    "marksman",
    "texlab",
    -- "ltex-ls",
  }

  local default_diagnostic_config = {
    signs = {
      active = true,
    },
    virtual_text = false,
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(default_diagnostic_config)

  local signs = {
    Error = icons.diagnostics.Error,
    Warn = icons.diagnostics.Warning,
    Hint = icons.diagnostics.Hint,
    Info = icons.diagnostics.Information,
  }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })
  require("lspconfig.ui.windows").default_options.border = "rounded"

  for _, server in pairs(servers) do
    local opts = {
      on_attach = M.on_attach,
      capabilities = M.common_capabilities(),
    }

    local lsp_settings_present, settings = pcall(require, "user.lspsettings." .. server)
    if lsp_settings_present then
      opts = vim.tbl_deep_extend("force", settings, opts)
    end

    if server == "lua_ls" then
      require("neodev").setup {}
    end

    if server == "clangd" then
      opts = vim.tbl_deep_extend("force", {
        filetypes = { "c", "cpp" },
        keys = {
          { "<leader>ch", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
        },
        capabilities = {
          offsetEncoding = { "utf-16" },
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
      }, opts)
    end

    lspconfig[server].setup(opts)
  end
end

return M
