[[ $- != *i* ]] && return

if [[ "$(uname)" == "Linux" ]]; then
  # On Linux with Omarchy, delegate everything to Omarchy's managed config
  source ~/.local/share/omarchy/default/bash/rc

  # Use GPG agent as SSH agent
  export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
else
  # macOS: replicate Omarchy's environment manually

  # --- Env ---
  export BAT_THEME="Catppuccin Mocha"
  export PATH="$PATH:$HOME/.local/bin"

  # Homebrew env (Apple Silicon path)
  [[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

  # --- Shell ---
  shopt -s histappend
  HISTCONTROL=ignoreboth
  HISTSIZE=32768
  HISTFILESIZE="${HISTSIZE}"

  if [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]]; then
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh"
  fi

  # --- Aliases: Filesystem ---
  if command -v eza &>/dev/null; then
    alias ls='eza -lh --group-directories-first --icons=auto'
    alias lsa='ls -a'
    alias lt='eza --tree --level=2 --long --icons --git'
    alias lta='lt -a'
  fi

  alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
  alias eff='$EDITOR "$(ff)"'

  if command -v zoxide &>/dev/null; then
    alias cd="zd"
    zd() {
      if (( $# == 0 )); then
        builtin cd ~ || return
      elif [[ -d $1 ]]; then
        builtin cd "$1" || return
      else
        if ! z "$@"; then
          echo "Error: Directory not found"
          return 1
        fi
        printf "\U000F17A9 "
        pwd
      fi
    }
  fi

  # --- Aliases: Directories ---
  alias ..='cd ..'
  alias ...='cd ../..'
  alias ....='cd ../../..'

  # --- Aliases: Tools ---
  alias cx='claude --allow-dangerously-skip-permissions'
  alias d='docker'
  alias r='rails'
  alias t='tmux attach || tmux new -s Work'
  n() { if [ "$#" -eq 0 ]; then command nvim . ; else command nvim "$@"; fi; }

  # --- Aliases: Git ---
  alias g='git'
  alias gcm='git commit -m'
  alias gcam='git commit -a -m'
  alias gcad='git commit -a --amend'

  # --- Functions: Compression ---
  compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
  alias decompress="tar -xzf"

  # --- Functions: Tmux layouts ---
  tdl() {
    [[ -z $1 ]] && { echo "Usage: tdl <ai_cmd> [<second_ai>]"; return 1; }
    [[ -z $TMUX ]] && { echo "You must start tmux to use tdl."; return 1; }
    local current_dir="${PWD}" editor_pane ai_pane ai2_pane ai="$1" ai2="$2"
    editor_pane="$TMUX_PANE"
    tmux rename-window -t "$editor_pane" "$(basename "$current_dir")"
    tmux split-window -v -p 15 -t "$editor_pane" -c "$current_dir"
    ai_pane=$(tmux split-window -h -p 30 -t "$editor_pane" -c "$current_dir" -P -F '#{pane_id}')
    if [[ -n $ai2 ]]; then
      ai2_pane=$(tmux split-window -v -t "$ai_pane" -c "$current_dir" -P -F '#{pane_id}')
      tmux send-keys -t "$ai2_pane" "$ai2" C-m
    fi
    tmux send-keys -t "$ai_pane" "$ai" C-m
    tmux send-keys -t "$editor_pane" "$EDITOR ." C-m
    tmux select-pane -t "$editor_pane"
  }

  tdlm() {
    [[ -z $1 ]] && { echo "Usage: tdlm <ai_cmd> [<second_ai>]"; return 1; }
    [[ -z $TMUX ]] && { echo "You must start tmux to use tdlm."; return 1; }
    local ai="$1" ai2="$2" base_dir="$PWD" first=true
    tmux rename-session "$(basename "$base_dir" | tr '.:' '--')"
    for dir in "$base_dir"/*/; do
      [[ -d $dir ]] || continue
      local dirpath="${dir%/}"
      if $first; then
        tmux send-keys -t "$TMUX_PANE" "cd '$dirpath' && tdl $ai $ai2" C-m
        first=false
      else
        local pane_id=$(tmux new-window -c "$dirpath" -P -F '#{pane_id}')
        tmux send-keys -t "$pane_id" "tdl $ai $ai2" C-m
      fi
    done
  }

  tsl() {
    [[ -z $1 || -z $2 ]] && { echo "Usage: tsl <pane_count> <command>"; return 1; }
    [[ -z $TMUX ]] && { echo "You must start tmux to use tsl."; return 1; }
    local count="$1" cmd="$2" current_dir="${PWD}"
    local -a panes
    tmux rename-window -t "$TMUX_PANE" "$(basename "$current_dir")"
    panes+=("$TMUX_PANE")
    while (( ${#panes[@]} < count )); do
      local new_pane
      new_pane=$(tmux split-window -h -t "${panes[-1]}" -c "$current_dir" -P -F '#{pane_id}')
      panes+=("$new_pane")
      tmux select-layout -t "${panes[0]}" tiled
    done
    for pane in "${panes[@]}"; do tmux send-keys -t "$pane" "$cmd" C-m; done
    tmux select-pane -t "${panes[0]}"
  }

  # --- Functions: Git worktrees ---
  ga() {
    [[ -z "$1" ]] && { echo "Usage: ga [branch name]"; return 1; }
    local branch="$1" base wt_path
    base="$(basename "$PWD")"
    wt_path="../${base}--${branch}"
    git worktree add -b "$branch" "$wt_path"
    mise trust "$wt_path" 2>/dev/null || true
    cd "$wt_path"
  }

  gd() {
    if gum confirm "Remove worktree and branch?"; then
      local cwd worktree root branch
      cwd="$(pwd)"
      worktree="$(basename "$cwd")"
      root="${worktree%%--*}"
      branch="${worktree#*--}"
      if [[ "$root" != "$worktree" ]]; then
        cd "../$root"
        git worktree remove "$cwd" --force || return 1
        git branch -D "$branch"
      fi
    fi
  }

  # --- Init ---
  if command -v mise &>/dev/null; then
    eval "$(mise activate bash)"
  fi

  if [[ $- == *i* ]] && [[ ${TERM:-} != "dumb" ]] && command -v starship &>/dev/null; then
    eval "$(starship init bash)"
  fi

  if command -v zoxide &>/dev/null; then
    eval "$(zoxide init bash)"
  fi

  if command -v fzf &>/dev/null; then
    [[ -f "$(brew --prefix)/opt/fzf/shell/completion.bash" ]] && \
      source "$(brew --prefix)/opt/fzf/shell/completion.bash"
    [[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.bash" ]] && \
      source "$(brew --prefix)/opt/fzf/shell/key-bindings.bash"
  fi
fi
