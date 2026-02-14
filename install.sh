#!/usr/bin/env bash
set -euo pipefail

# ===========================================
# dotfiles bootstrap script
# Supports: macOS, Ubuntu/Debian Linux
# ===========================================

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# --- Helpers ---
info()  { printf '\033[1;34m[info]\033[0m  %s\n' "$1"; }
ok()    { printf '\033[1;32m[ok]\033[0m    %s\n' "$1"; }
warn()  { printf '\033[1;33m[warn]\033[0m  %s\n' "$1"; }
error() { printf '\033[1;31m[error]\033[0m %s\n' "$1" >&2; exit 1; }

# --- OS Detection ---
detect_os() {
  case "$(uname -s)" in
    Darwin) OS="macos" ;;
    Linux)
      if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
          ubuntu|debian) OS="ubuntu" ;;
          *) OS="linux" ;;
        esac
      else
        OS="linux"
      fi
      ;;
    *) error "Unsupported OS: $(uname -s)" ;;
  esac
  info "Detected OS: $OS"
}

# --- Homebrew ---
install_homebrew() {
  if command -v brew &>/dev/null; then
    ok "Homebrew already installed"
    return
  fi
  info "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add brew to PATH for this session
  if [ "$OS" = "macos" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  fi
  ok "Homebrew installed"
}

# --- Packages ---
install_packages() {
  info "Installing packages via brew bundle..."
  if [ "$OS" = "macos" ]; then
    brew bundle --file="$DOTFILES_DIR/Brewfile"
  else
    # Skip cask lines on Linux
    grep -v '^cask ' "$DOTFILES_DIR/Brewfile" | brew bundle --file=/dev/stdin
  fi
  ok "Packages installed"
}

# --- Symlinks ---
create_symlinks() {
  info "Creating symlinks..."

  local configs=(
    "zsh"
    "sheldon"
    "nvim"
    "wezterm"
    "tmux"
    "git"
  )

  # starship.toml (file, not directory)
  ln -sfn "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"

  for dir in "${configs[@]}"; do
    if [ -d "$DOTFILES_DIR/.config/$dir" ]; then
      mkdir -p "$HOME/.config"
      ln -sfn "$DOTFILES_DIR/.config/$dir" "$HOME/.config/$dir"
      ok "Linked .config/$dir"
    fi
  done

  # .bashrc
  if [ -f "$DOTFILES_DIR/.bashrc" ]; then
    ln -sfn "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
    ok "Linked .bashrc"
  fi

  ok "Symlinks created"
}

# --- Default Shell ---
set_default_shell() {
  local zsh_path
  zsh_path="$(command -v zsh)"

  if [ "$SHELL" = "$zsh_path" ]; then
    ok "zsh is already the default shell"
    return
  fi

  info "Setting zsh as default shell..."
  if ! grep -qF "$zsh_path" /etc/shells; then
    echo "$zsh_path" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$zsh_path"
  ok "Default shell set to zsh"
}

# --- Sheldon ---
init_sheldon() {
  if ! command -v sheldon &>/dev/null; then
    warn "sheldon not found, skipping plugin init"
    return
  fi
  info "Initializing sheldon plugins..."
  sheldon lock
  ok "Sheldon plugins locked"
}

# --- ZDOTDIR ---
setup_zdotdir() {
  local zshenv="$HOME/.zshenv"
  local line='export ZDOTDIR="$HOME/.config/zsh"'

  if [ -f "$zshenv" ] && grep -qF 'ZDOTDIR' "$zshenv"; then
    ok "ZDOTDIR already set in .zshenv"
    return
  fi

  info "Setting ZDOTDIR in ~/.zshenv..."
  echo "$line" >> "$zshenv"
  ok "ZDOTDIR configured"
}

# --- Main ---
main() {
  info "Starting dotfiles installation..."
  detect_os
  install_homebrew
  install_packages
  create_symlinks
  setup_zdotdir
  set_default_shell
  init_sheldon
  echo ""
  ok "dotfiles installation complete!"
  info "Open a new terminal or run: exec zsh"
}

main "$@"
