# dotfiles

Personal dotfiles optimized for Claude Code workflow. Ubuntu/macOS cross-platform.

## What's Included

- **zsh** + sheldon (autosuggestions, syntax highlighting, completions)
- **Neovim** (LazyVim) + lazygit.nvim, treesitter
- **WezTerm** terminal emulator
- **tmux** with Catppuccin Mocha theme
- **Git** with delta (side-by-side diffs), useful aliases
- **Starship** prompt (Catppuccin Mocha)
- Modern CLI: `eza`, `bat`, `ripgrep`, `fd`, `zoxide`, `fzf`, `direnv`, `gh`

## Quick Start

```bash
git clone https://github.com/kkaoioi/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

The install script will:
1. Detect your OS (macOS / Ubuntu)
2. Install Homebrew if needed
3. Install all packages via `brew bundle`
4. Create symlinks to `~/.config/`
5. Set zsh as default shell
6. Initialize sheldon plugins

## Structure

```
dotfiles/
├── install.sh                  # Bootstrap script
├── Brewfile                    # Homebrew packages
├── .bashrc                     # Bash config (fallback)
├── .config/
│   ├── zsh/.zshrc              # Zsh config
│   ├── sheldon/plugins.toml    # Zsh plugins
│   ├── nvim/                   # Neovim (LazyVim)
│   ├── wezterm/                # WezTerm
│   ├── tmux/tmux.conf          # tmux
│   ├── git/config              # Git + delta
│   ├── git/ignore              # Global gitignore
│   └── starship.toml           # Starship prompt
```

## Key Bindings

### tmux (prefix: `Ctrl+a`)

| Key | Action |
|-----|--------|
| `\|` | Split horizontal |
| `-` | Split vertical |
| `h/j/k/l` | Navigate panes |
| `c` | New window |
| `r` | Reload config |

### Zsh Aliases

| Alias | Command |
|-------|---------|
| `ls` | `eza --icons` |
| `cat` | `bat` |
| `grep` | `rg` |
| `cd` | `z` (zoxide) |
| `lg` | `lazygit` |
