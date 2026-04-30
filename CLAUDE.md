# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles repository inspired by [Omarchy](https://omarchy.org/). Supports Linux (Omarchy/Hyprland) and macOS with Homebrew. Shell is **zsh** (managed by sheldon). Terminal is **WezTerm**. Includes configuration for: Neovim (LazyVim), tmux, Git (delta), Starship prompt, and various modern CLI tools.

## Repository Structure

```
dotfiles/
├── install.sh              # Bootstrap script (OS detection, brew, symlinks)
├── Brewfile                # Declarative Homebrew packages
├── .config/
│   ├── wezterm/            # WezTerm terminal config (wezterm.lua, keybinds.lua)
│   ├── zsh/                # Zsh config (.zshrc — ZDOTDIR points here)
│   ├── nvim/               # Neovim (LazyVim)
│   │   └── lua/plugins/
│   │       └── claude.lua  # Treesitter languages + lazygit.nvim
│   ├── tmux/tmux.conf      # tmux config (Ctrl+Space prefix, Catppuccin)
│   ├── git/
│   │   ├── config          # Git config (delta, aliases, push.autoSetupRemote)
│   │   └── ignore          # Global gitignore
│   ├── hypr/               # Hyprland WM config (Linux)
│   ├── waybar/             # Waybar status bar (Linux)
│   ├── mako/               # Mako notification daemon (Linux)
│   ├── walker/             # Walker app launcher (Linux)
│   ├── lazygit/            # lazygit config
│   └── starship.toml       # Starship prompt (Catppuccin Mocha)
```

## Key Conventions

- **Theme**: Catppuccin Mocha palette across Starship, tmux, WezTerm, and editor
- **Shell**: zsh — sheldon manages plugins, ZDOTDIR=`~/.config/zsh`
- **Terminal**: WezTerm
- **Plugin management**: lazy.nvim for Neovim
- **Neovim**: LazyVim-based. Custom plugins in `.config/nvim/lua/plugins/`. Config in `.config/nvim/lua/config/`
- **tmux**: Prefix is `Ctrl+Space`, vi mode, mouse enabled
- **Git**: delta as pager (side-by-side diffs), push.autoSetupRemote enabled
- **Zsh aliases**: `ls`→`eza`, `cd`→`z` (zoxide), `cat`→`bat`, `grep`→`rg`, `lg`→lazygit

## CLI Tools

| Tool | Replaces | Purpose |
|------|----------|---------|
| eza | ls | File listing with icons |
| bat | cat | Syntax-highlighted file viewing |
| ripgrep (rg) | grep | Fast content search |
| fd | find | Fast file search |
| zoxide (z) | cd | Smart directory jumping (`zd` wrapper) |
| fzf | — | Fuzzy finder (Ctrl+T, Ctrl+R, Alt+C) |
| delta | — | Git diff syntax highlighting |
| lazygit | — | Git TUI |
| gh | — | GitHub CLI |
| mise | nvm/rbenv | Runtime version management |
| gum | — | Interactive shell scripts |
| starship | — | Cross-shell prompt |

## Deployment

```bash
git clone https://github.com/kkaoioi/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
exec zsh
```

**Verify Installation:**
- `echo $SHELL` → should show zsh path
- `which eza bat rg fd` → all should resolve
- `nvim --version` → should show Neovim installed
- `tmux -V` → should show tmux version

## Common Workflows

### Update Packages
```bash
cd ~/dotfiles
brew update && brew upgrade
```

### Add New Package
1. Add to `Brewfile`
2. Run `brew bundle --file=~/dotfiles/Brewfile`
3. Commit and push changes

### Test Changes
Before committing config changes:
```bash
# For zsh changes
exec zsh

# For tmux changes
tmux source ~/.config/tmux/tmux.conf

# For Neovim changes (inside nvim)
:Lazy sync
```

### Sync to New Machine
```bash
cd ~/dotfiles
git pull
bash install.sh
exec zsh
```

## Customization

### Modify Neovim Config
- Add plugins: `.config/nvim/lua/plugins/` (create new `.lua` file)
- Modify settings: `.config/nvim/lua/config/options.lua`, `keymaps.lua`, etc.
- Sync changes: `:Lazy sync` inside nvim

### Change Theme
Current: Catppuccin Mocha
- Starship: `.config/starship.toml`
- tmux: `.config/tmux/tmux.conf` (catppuccin plugin section)
- WezTerm: `.config/wezterm/wezterm.lua`
- Neovim: LazyVim colorscheme config

### Add Homebrew Package
1. Edit `Brewfile`
2. Add `brew "package-name"` or `cask "app-name"`
3. Run `brew bundle --file=~/dotfiles/Brewfile`

## Environment Details

### Key Environment Variables (macOS)
- `BAT_THEME="Catppuccin Mocha"` - bat color theme

### Directory Structure
- `~/.config/` - All dotfile configs (symlinked from `~/dotfiles/.config/`)
- `~/.zshenv` - Sets `ZDOTDIR="$HOME/.config/zsh"` (written by install.sh)

## Tool Integration

### fzf + bat Integration
- `ff` alias — fzf with bat preview
- `eff` alias — open fzf-selected file in `$EDITOR`
- `Ctrl+T` / `Ctrl+R` / `Alt+C` — standard fzf key bindings

### Tmux Layout Functions
- `tdl <ai_cmd>` — splits window into editor + AI pane(s)
- `tdlm <ai_cmd>` — runs `tdl` across all subdirectories (one tmux window each)
- `tsl <count> <cmd>` — opens N tiled panes all running the same command

### Git Worktree Functions
- `ga <branch>` — creates worktree at `../<repo>--<branch>`, runs `mise trust`, cds into it
- `gd` — removes current worktree and deletes branch (with gum confirmation)

### mise (Runtime Manager)
Replaces nvm/rbenv. Activated in `.config/zsh/.zshrc` via `mise activate zsh`.

## Gotchas

- **Symlinks overwrite**: `install.sh` will replace existing configs in `~/.config/`. Back up first if needed.
- **Linux limitations**: Homebrew casks (GUI apps) are skipped on Ubuntu/Debian.
- **New terminal required**: After install, run `exec zsh` or open a new terminal to load changes.
- **ZDOTDIR**: `.zshrc` lives at `~/.config/zsh/.zshrc`. `~/.zshenv` must set `ZDOTDIR` for zsh to find it (handled by install.sh).
