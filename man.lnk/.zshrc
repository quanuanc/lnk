# Equivalent zsh configuration for the current fish config, plus fish-like
# interactive features for highlighting, suggestions, completion, and history.

if [[ -o interactive ]]; then
  export http_proxy="http://127.0.0.1:6152"
  export https_proxy="http://127.0.0.1:6152"
  export all_proxy="socks5://127.0.0.1:6153"

  export GOPATH="$HOME/.local/go"
  export GOBIN="$GOPATH/bin"
  export GOCACHE="$HOME/.cache/go"

  # export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
  export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
  export HOMEBREW_BOTTLE_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles"

  alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

  # Keep zsh history useful for prefix search and autosuggestions.
  HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
  HISTSIZE=100000
  SAVEHIST=100000
  [[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}" 2>/dev/null
  setopt EXTENDED_HISTORY
  setopt HIST_IGNORE_DUPS
  setopt HIST_IGNORE_SPACE
  setopt HIST_REDUCE_BLANKS
  setopt INC_APPEND_HISTORY
  setopt SHARE_HISTORY

  # Completion: use Homebrew zsh-completions when present, with a cached dump
  # so normal shell startup does not pay the full compinit scan every time.
  typeset -U fpath path PATH
  typeset -a _zsh_completion_dirs
  _zsh_completion_dirs=(
    /opt/homebrew/share/zsh-completions
    /opt/homebrew/opt/zsh-completions/share/zsh-completions
    /usr/local/share/zsh-completions
    /usr/local/opt/zsh-completions/share/zsh-completions
  )
  for _dir in "${_zsh_completion_dirs[@]}"; do
    [[ -d "$_dir" ]] && fpath=("$_dir" $fpath)
  done
  unset _dir

  autoload -Uz compinit
  _zcompdump_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
  _zcompdump="$_zcompdump_dir/zcompdump-${ZSH_VERSION}"
  [[ -d "$_zcompdump_dir" ]] || mkdir -p "$_zcompdump_dir" 2>/dev/null
  _rebuild_compdump=
  if [[ ! -s "$_zcompdump" ]]; then
    _rebuild_compdump=1
  else
    for _dir in "${_zsh_completion_dirs[@]}"; do
      [[ -d "$_dir" && "$_zcompdump" -ot "$_dir" ]] && _rebuild_compdump=1
    done
  fi
  if [[ -n "$_rebuild_compdump" ]]; then
    compinit -u -d "$_zcompdump"
  else
    compinit -C -d "$_zcompdump"
  fi
  unset _dir _rebuild_compdump _zcompdump _zcompdump_dir _zsh_completion_dirs

  zmodload zsh/complist 2>/dev/null
  zstyle ':completion:*' menu select
  zstyle ':completion:*' group-name ''
  zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

  # Prefix history search with Up/Down, matching fish's familiar behavior.
  autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
  zle -N up-line-or-beginning-search
  zle -N down-line-or-beginning-search
  zmodload zsh/terminfo 2>/dev/null
  [[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
  [[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
  bindkey '^[[A' up-line-or-beginning-search
  bindkey '^[[B' down-line-or-beginning-search

  if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
  fi

  if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh --disable-up-arrow)"
  fi

  # Fish-like autosuggestions. Use fixed paths instead of `brew --prefix` to
  # avoid launching Homebrew on every shell startup.
  ZSH_AUTOSUGGEST_STRATEGY=(history)
  ZSH_AUTOSUGGEST_USE_ASYNC=1
  for _plugin in \
    /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /opt/homebrew/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
    /usr/local/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh; do
    if [[ -r "$_plugin" ]]; then
      source "$_plugin"
      break
    fi
  done
  unset _plugin

  # Syntax highlighting should be loaded near the end of .zshrc.
  for _plugin in \
    /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /opt/homebrew/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
    /usr/local/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh; do
    if [[ -r "$_plugin" ]]; then
      source "$_plugin"
      break
    fi
  done
  unset _plugin
fi
