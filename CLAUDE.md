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
│   ├── tmux/tmux.conf      # tmux config (Ctrl+Space prefix, Catppuccin)
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
- **tmux**: Prefix is `Ctrl+Space`, vi mode, mouse enabled
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
git clone https://github.com/kkaoioi/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
exec zsh  # Load new config
```

The install script handles: OS detection, Homebrew install, `brew bundle`, symlink creation, zsh as default shell, and sheldon plugin initialization.

**Verify Installation:**
- `echo $SHELL` → should show zsh path
- `which eza bat rg fd z` → all should resolve
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

### Update Zsh Plugins
```bash
sheldon lock --update
```

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

### Add Zsh Plugin
1. Edit `.config/sheldon/plugins.toml`
2. Add plugin entry:
   ```toml
   [plugins.my-plugin]
   github = "user/repo"
   ```
3. Run `sheldon lock` and `exec zsh`

### Modify Neovim Config
- Add plugins: `.config/nvim/lua/plugins/` (create new `.lua` file)
- Modify settings: `.config/nvim/lua/config/options.lua`, `keymaps.lua`, etc.
- Sync changes: `:Lazy sync` inside nvim

### Change Theme
Current: Catppuccin Mocha
- Starship: `.config/starship.toml` (line with `palette =`)
- tmux: `.config/tmux/tmux.conf` (catppuccin plugin section)
- Neovim: LazyVim colorscheme config

### Add Homebrew Package
1. Edit `Brewfile`
2. Add `brew "package-name"` or `cask "app-name"`
3. Run `brew bundle --file=~/dotfiles/Brewfile`

## Environment Details

### Key Environment Variables
- `ZDOTDIR="$HOME/.config/zsh"` - Zsh config location (set in `~/.zshenv`)
- `HISTFILE="$HOME/.local/state/zsh/history"` - Zsh history location
- `NVM_DIR="$HOME/.nvm"` - nvm installation directory
- `FZF_DEFAULT_COMMAND` - fd integration for fzf

### Directory Structure
- `~/.config/` - All dotfile configs (symlinked from `~/dotfiles/.config/`)
- `~/.local/state/zsh/` - Zsh runtime data (history)
- `~/.zshenv` - Sets ZDOTDIR (created by install.sh)

## Tool Integration

### Zsh Plugin Loading Order
Sheldon loads plugins in specific order (`.config/sheldon/plugins.toml`):
1. `zsh-autosuggestions` - Command suggestions from history
2. `zsh-completions` - Enhanced completions
3. `compinit` - Initialize completion system
4. `zsh-syntax-highlighting` - Must load last for proper highlighting

### fzf + fd Integration
- `Ctrl+T` - File search using fd (excludes .git)
- `Ctrl+R` - Command history search
- `Alt+C` - Directory jump using fd
- Default command: `fd --type f --hidden --follow --exclude .git`

### nvm (Lazy Load)
Node Version Manager loads on first `nvm` command to improve shell startup time. Located in `.zshrc` lines 48+.

### WezTerm + tmux
- **WezTerm**: GPU-accelerated terminal emulator (custom keybinds in `.config/wezterm/keybinds.lua`)
- **tmux**: Terminal multiplexer inside WezTerm (prefix: `Ctrl+Space`)
- Can be used independently or together (tmux for session persistence, WezTerm for rendering)

## Gotchas

- **ZDOTDIR**: The zsh config lives in `.config/zsh/`, not `~/.zshrc`. The install script sets `ZDOTDIR` in `~/.zshenv`.
- **Symlinks overwrite**: `install.sh` will replace existing configs in `~/.config/`. Back up first if needed.
- **Linux limitations**: Homebrew casks (GUI apps) are skipped on Ubuntu/Debian.
- **New terminal required**: After install, run `exec zsh` or open a new terminal to load changes.
- **zcompdump files**: Auto-generated `.zcompdump.*` files in `.config/zsh/` can be gitignored.

## Troubleshooting

### Sheldon plugins not loading
```bash
# Check sheldon is installed
which sheldon

# Re-lock plugins
sheldon lock

# Reload shell
exec zsh
```

### Symlink conflicts
```bash
# Check what's linked
ls -la ~/.config/zsh
ls -la ~/.config/nvim

# If conflicts exist, backup and re-run
mv ~/.config/zsh ~/.config/zsh.backup
cd ~/dotfiles && bash install.sh
```

### Commands not found after install
```bash
# Ensure brew is in PATH
which brew

# macOS
eval "$(/opt/homebrew/bin/brew shellenv)"

# Linux
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
```

### zsh history not persisting
Check `$HISTFILE` location: `~/.local/state/zsh/history`
```bash
mkdir -p ~/.local/state/zsh
```
