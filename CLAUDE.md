# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository optimized for Claude Code workflow. Supports Ubuntu and macOS with Homebrew. Includes configuration for: zsh (sheldon), Neovim (LazyVim), WezTerm, tmux, Git (delta), Starship prompt, and various modern CLI tools.

## Repository Structure

```
dotfiles/
├── install.sh              # Bootstrap script (OS detection, brew, symlinks)
├── Brewfile                # Declarative Homebrew packages
├── .bashrc                 # Bash shell config (fallback)
├── .config/
│   ├── zsh/.zshrc          # Zsh config (sheldon plugins, lazy nvm, direnv)
│   ├── sheldon/plugins.toml# Zsh plugin definitions
│   ├── nvim/               # Neovim (LazyVim)
│   │   └── lua/plugins/
│   │       └── claude.lua  # Treesitter languages + lazygit.nvim
│   ├── wezterm/            # WezTerm terminal config (Lua)
│   ├── tmux/tmux.conf      # tmux config (Ctrl+a prefix, Catppuccin)
│   ├── git/
│   │   ├── config          # Git config (delta, aliases, push.autoSetupRemote)
│   │   └── ignore          # Global gitignore
│   └── starship.toml       # Starship prompt (Catppuccin Mocha)
```

## Key Conventions

- **Theme**: Catppuccin Mocha palette across Starship, tmux, and editor
- **Font**: Hack Nerd Font (set in WezTerm)
- **Plugin management**: sheldon for zsh, lazy.nvim for Neovim
- **Neovim**: LazyVim-based. Custom plugins in `.config/nvim/lua/plugins/`. Config in `.config/nvim/lua/config/`
- **WezTerm**: Keybindings in `.config/wezterm/keybinds.lua`, default bindings disabled
- **tmux**: Prefix is `Ctrl+a`, vi mode, mouse enabled
- **Git**: delta as pager (side-by-side diffs), push.autoSetupRemote enabled
- **Zsh aliases**: `ls`→`eza`, `cat`→`bat`, `grep`→`rg`, `cd`→`z`, `lg`→`lazygit`
- **Lua formatting**: StyLua — 2-space indent, 120 column width (`.config/nvim/stylua.toml`)

## CLI Tools

| Tool | Replaces | Purpose |
|------|----------|---------|
| eza | ls | File listing with icons |
| bat | cat | Syntax-highlighted file viewing |
| ripgrep (rg) | grep | Fast content search |
| fd | find | Fast file search |
| zoxide (z) | cd | Smart directory jumping |
| fzf | — | Fuzzy finder (Ctrl+T, Ctrl+R, Alt+C) |
| delta | — | Git diff syntax highlighting |
| lazygit | — | Git TUI |
| gh | — | GitHub CLI |
| direnv | — | Per-project environment variables |
| sheldon | — | Zsh plugin manager |

## Deployment

```bash
git clone <repo> ~/dotfiles
cd ~/dotfiles
bash install.sh
```

The install script handles: OS detection, Homebrew install, `brew bundle`, symlink creation, zsh as default shell, and sheldon plugin initialization.
