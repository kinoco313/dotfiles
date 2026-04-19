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
  mkdir -p "$HOME/.config"

  local configs=(
    "nvim"
    "tmux"
    "git"
    "lazygit"
    "alacritty"
  )

  # Linux-only configs (Hyprland / Wayland ecosystem)
  local linux_configs=(
    "hypr"
    "waybar"
    "walker"
    "mako"
  )

  # starship.toml is a file, not a directory
  ln -sfn "$DOTFILES_DIR/.config/starship.toml" "$HOME/.config/starship.toml"
  ok "Linked .config/starship.toml"

  for dir in "${configs[@]}"; do
    if [ -d "$DOTFILES_DIR/.config/$dir" ]; then
      ln -sfn "$DOTFILES_DIR/.config/$dir" "$HOME/.config/$dir"
      ok "Linked .config/$dir"
    fi
  done

  if [ "$OS" = "linux" ] || [ "$OS" = "ubuntu" ]; then
    for dir in "${linux_configs[@]}"; do
      if [ -d "$DOTFILES_DIR/.config/$dir" ]; then
        ln -sfn "$DOTFILES_DIR/.config/$dir" "$HOME/.config/$dir"
        ok "Linked .config/$dir (Linux only)"
      fi
    done
  fi

  # .bashrc
  if [ -f "$DOTFILES_DIR/.bashrc" ]; then
    ln -sfn "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
    ok "Linked .bashrc"
  fi

  ok "Symlinks created"
}

# --- Default Shell (bash 5.x via brew) ---
set_default_shell() {
  local bash_path
  if [ "$OS" = "macos" ]; then
    bash_path="$(brew --prefix)/bin/bash"
  else
    bash_path="$(command -v bash)"
  fi

  if [ "$SHELL" = "$bash_path" ]; then
    ok "bash is already the default shell"
    return
  fi

  info "Setting bash as default shell ($bash_path)..."
  if ! grep -qF "$bash_path" /etc/shells; then
    echo "$bash_path" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$bash_path"
  ok "Default shell set to bash"
}

# --- Main ---
main() {
  info "Starting dotfiles installation..."
  detect_os
  install_homebrew
  install_packages
  create_symlinks
  set_default_shell
  echo ""
  ok "dotfiles installation complete!"
  info "Open a new terminal or run: exec bash"
}

main "$@"
