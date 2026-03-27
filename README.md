# Neovim Config

Personal Neovim configuration, originally forked from [Launch.nvim](https://github.com/LunarVim/Launch.nvim) and heavily customized.

## Structure

```
init.lua                    → Entry point, registers all plugin specs
lua/user/launch.lua         → Defines spec() helper, populates LAZY_PLUGIN_SPEC
lua/user/lazy.lua           → Bootstraps lazy.nvim with collected specs
lua/user/options.lua        → Core Neovim options (2-space indent, OSC52 clipboard)
lua/user/keymaps.lua        → Global keymaps (leader = Space, jk = Escape)
lua/user/autocmds.lua       → Autocommands
lua/user/*.lua              → One file per plugin (each returns a LazyPluginSpec)
lua/user/extras/*.lua       → Optional/experimental plugins (same pattern)
lua/user/lspsettings/*.lua  → Per-LSP server settings (auto-loaded by lspconfig)
lua/user/dapsettings/       → DAP debugger configurations
```

## Key Plugins

- **Completion**: blink.nvim
- **LSP**: lspconfig + Mason (lua_ls, clangd, fortls, bashls, marksman, texlab)
- **Fuzzy finder**: fzf-lua
- **Git**: gitsigns, fugitive, neogit, diffview, blame.nvim
- **Navigation**: flash.nvim, harpoon, nvim-tree, dropbar
- **AI**: Avante (Claude via ACP), Claude Code integration, Sidekick
- **UI**: noice, lualine, snacks.nvim, which-key, indentline, rainbow-delimiters
- **Editing**: mini.ai, mini.surround, mini.align, autopairs, comment, yanky

## Install Neovim 0.11.6

You can install Neovim with your package manager (e.g. brew, apt, pacman), but note that updating packages may upgrade Neovim to a newer version.

To pin to a specific version, install from source: [instructions](https://github.com/neovim/neovim/wiki/Installing-Neovim#install-from-source)

## Install the config

Make sure to remove or backup your current `nvim` directory:

```sh
git clone <this-repo-url> ~/.config/nvim
```

Run `nvim` and wait for the plugins to be installed.

**TIP**: After the initial install, plugins will be at their latest versions.
To pin them to the known-good versions recorded in `lazy-lock.json`, run
`:Lazy restore` inside Neovim. For a headless first-time setup that installs
and restores in one shot:

```sh
nvim --headless "+Lazy! restore" +qa
```

**NOTE**: Treesitter will pull in parsers the next time you open Neovim.

## Prerequisites

Run `:checkhealth` in Neovim to verify your setup.

### Clipboard

- On macOS: `pbcopy` is builtin
- On Ubuntu:
  ```sh
  sudo apt install xsel        # for X11
  sudo apt install wl-clipboard # for Wayland
  ```

### ripgrep (required for fzf-lua)

```sh
sudo apt install ripgrep
```

### Node.js

Required by Avante (for `npx @zed-industries/claude-agent-acp`).

### Nerd Font

A font with icon support is required. Install one via [getnf](https://github.com/ronniedroid/getnf).

## Adding a Plugin

1. Create `lua/user/myplugin.lua` returning a lazy.nvim spec table
2. Add `spec "user.myplugin"` in `init.lua`
3. For experimental plugins, use `lua/user/extras/` and optionally comment out the spec line
