. "$HOME/.local/bin/env"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Tools Setup
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

# Aliases
alias ls='eza --icons --group-directories-first'
alias ll='eza -al --icons --group-directories-first'
alias cat='bat'
alias grep='rg'
alias cd='z'

