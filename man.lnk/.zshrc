[[ -o interactive ]] || return

proxy_on() {
  export http_proxy="http://127.0.0.1:6152"
  export https_proxy="$http_proxy"
  export all_proxy="socks5://127.0.0.1:6153"
}

proxy_off() {
  unset http_proxy https_proxy all_proxy
}

proxy_on

alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
mkdir -p "${HISTFILE:h}"
setopt EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS INC_APPEND_HISTORY SHARE_HISTORY

typeset -U fpath path PATH

source /opt/homebrew/opt/antidote/share/antidote/antidote.zsh
antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.pre.txt"

autoload -Uz compinit
compinit -C -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-${ZSH_VERSION}"

zmodload zsh/complist 2>/dev/null
zstyle ':completion:*' menu select
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}%d%f'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zmodload zsh/terminfo 2>/dev/null
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" up-line-or-beginning-search
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

eval "$(zoxide init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(mise activate zsh)"

ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_USE_ASYNC=1
antidote load "${ZDOTDIR:-$HOME}/.zsh_plugins.txt"
