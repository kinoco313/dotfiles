# ===========================================
# .zshrc — Primary shell configuration
# ===========================================

# --- Homebrew ---
if [[ "$(uname -s)" == "Darwin" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# --- Sheldon (plugin manager) ---
eval "$(sheldon source)"

# --- History ---
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt SHARE_HISTORY
setopt APPEND_HISTORY
mkdir -p "${HISTFILE:h}"

# --- Tools ---
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
eval "$(direnv hook zsh)"

# fzf keybindings and completion
source <(fzf --zsh)

# fzf + fd integration
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# --- Aliases ---
alias ls='eza --icons --group-directories-first'
alias ll='eza -al --icons --group-directories-first'
alias la='eza -a --icons --group-directories-first'
alias tree='eza --tree --icons'
alias cat='bat'
alias grep='rg'
alias cd='z'
alias lg='lazygit'

# --- nvm (lazy load) ---
export NVM_DIR="$HOME/.nvm"
nvm() {
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  nvm "$@"
}
node() {
  unfunction node npm npx 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  node "$@"
}
npm() {
  unfunction node npm npx 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  npm "$@"
}
npx() {
  unfunction node npm npx 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  npx "$@"
}
export PATH="$HOME/.local/bin:$PATH"
