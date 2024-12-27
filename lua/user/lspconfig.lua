local M = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "folke/neodev.nvim",
    },
  },
}

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
end

--- @type vim.lsp.client.on_attach_cb
M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)

  -- if client.supports_method "textDocument/inlayHint" then
  --   vim.lsp.inlay_hint.enable(true, { bufnr })
  -- end

  -- Use lsp-signature for showing function signatures when typing
  local lsp_signature_present, lsp_signature = pcall(require, "lsp_signature")
  if not lsp_signature_present then
    return
  end

  -- Disable lsp_signature for specific lsps
  if vim.tbl_contains({ "null-ls" }, client.name) then -- blacklist lsp
    return
  end

  local icons = require "user.icons"
  local signature_config = {
    -- Setup options for lsp_signature
    hint_prefix = icons.misc.Dog .. " ",
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
  local wk = require "which-key"
  wk.add {
    { "<leader>l", group = "LSP" },
    { "<leader>lA", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action (without Preview)" },
    { "<leader>ld", "<cmd>lua require('user.lspconfig').toggle_diagnostics()<cr>", desc = "Toggle Diagnostics" },
    {
      "<leader>lf",
      "<cmd>lua vim.lsp.buf.format({async = true, filter = function(client) return client.name ~= 'typescript-tools' end})<cr>",
      desc = "Format",
    },
    { "<leader>lh", "<cmd>lua require('user.lspconfig').toggle_inlay_hints()<cr>", desc = "Hints" },
    { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
    { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
    { "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<cr>", desc = "Quickfix" },
    { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
    -- Visual mode shortcuts
    { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action", mode = "v" },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format({async=true})<cr>", desc = "Code Format", mode = "v" },
  }

  -- Use tiny-inline-diagnostic shortcuts to show diagnostics floats, if available
  local tid_present, _ = pcall(require, "tiny-inline-diagnostic")
  if tid_present then
    wk.add {
      { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({float = false})<cr>", desc = "Next Diagnostic" },
      { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({float = false})<cr>", desc = "Prev Diagnostic" },
      { "<leader>lt", "<cmd>lua require('tiny-inline-diagnostic').toggle()<cr>", desc = "Toggle Floating Diagnostics" },
    }
  else
    wk.add {
      { "<leader>lj", "<cmd>lua vim.diagnostic.goto_next()<cr>", desc = "Next Diagnostic" },
      { "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
    }
  end

  local lspconfig = require "lspconfig"
  local icons = require "user.icons"

  local servers = {
    "lua_ls",
    "clangd",
    "fortls",
    "bashls",
    "marksman",
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
          offsetencoding = { "utf-16" },
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        setup = {
          clangd = function(_, opts)
            local clangd_ext_present, clangd_extensions = pcall(require, "clangd_extensions")
            if not clangd_ext_present then
              return
            end
            clangd_extensions.setup(vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts }))
            return false
          end,
        },
      }, opts)
    end

    lspconfig[server].setup(opts)
  end
end

return M
