# dotfiles

Personal dotfiles optimized for Claude Code workflow. Linux (Omarchy/Hyprland) + macOS cross-platform.

## What's Included

- **bash** shell config (delegates to Omarchy on Linux, standalone on macOS)
- **Hyprland** window manager configs (bindings, autostart, idle, lock, look & feel)
- **Waybar** status bar
- **Alacritty** terminal emulator
- **Neovim** (LazyVim) + lazygit.nvim, treesitter
- **tmux** with Catppuccin Mocha theme
- **Git** with delta (side-by-side diffs), useful aliases
- **Starship** prompt
- **Walker** app launcher
- **Mako** notification daemon
- Modern CLI: `eza`, `bat`, `ripgrep`, `fd`, `zoxide`, `fzf`, `lazygit`, `gh`, `direnv`, `mise`

## Quick Start

```bash
git clone https://github.com/kkaoioi/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh
```

The install script will:
1. Detect your OS (macOS / Linux)
2. Install Homebrew if needed
3. Install all packages via `brew bundle`
4. Create symlinks to `~/.config/`

## Structure

```
dotfiles/
├── install.sh                  # Bootstrap script
├── Brewfile                    # Homebrew packages
├── .bashrc                     # Bash config (delegates to Omarchy on Linux)
├── .config/
│   ├── hypr/                   # Hyprland WM config
│   │   ├── hyprland.conf       # Main config
│   │   ├── bindings.conf       # Keybindings
│   │   ├── autostart.conf      # Autostart apps
│   │   ├── hypridle.conf       # Idle management
│   │   ├── hyprlock.conf       # Lock screen
│   │   ├── hyprsunset.conf     # Night light
│   │   ├── input.conf          # Input devices
│   │   ├── looknfeel.conf      # Theme/appearance
│   │   ├── monitors.conf       # Monitor layout
│   │   └── xdph.conf           # XDG desktop portal
│   ├── waybar/                 # Status bar
│   │   ├── config.jsonc        # Modules config
│   │   └── style.css           # Styling
│   ├── alacritty/alacritty.toml# Terminal emulator
│   ├── walker/                 # App launcher
│   ├── mako/                   # Notifications
│   ├── nvim/                   # Neovim (LazyVim)
│   ├── tmux/tmux.conf          # tmux
│   ├── git/config              # Git + delta
│   ├── git/ignore              # Global gitignore
│   └── starship.toml           # Starship prompt
```

## Key Bindings

### tmux (prefix: `Ctrl+Space`)

| Key | Action |
|-----|--------|
| `v` | Split pane vertically (left/right) |
| `h` | Split pane horizontally (top/bottom) |
| `Ctrl+Alt+↑/↓/←/→` | Navigate panes |
| `x` | Kill pane |
| `c` | New window |
| `k` | Kill window |
| `r` | Rename window |
| `q` | Reload config |
| `Alt+1~9` | Switch window by number |
| `Alt+←/→` | Switch window prev/next |

### Bash Aliases

| Alias | Command |
|-------|---------|
| `ls` | `eza --icons` |
| `cat` | `bat` |
| `grep` | `rg` |
| `cd` | `z` (zoxide) |
| `lg` | `lazygit` |
