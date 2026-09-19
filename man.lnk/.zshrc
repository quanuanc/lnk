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

# Use the unprivileged userspace tailscaled instance.
tailscale() {
  command /opt/homebrew/bin/tailscale \
    --socket="$HOME/.local/share/tailscale-socks/tailscaled.sock" \
    "$@"
}
alias psql="/Applications/Postgres.app/Contents/Versions/latest/bin/psql"

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
mkdir -p "${HISTFILE:h}"
setopt EXTENDED_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS INC_APPEND_HISTORY SHARE_HISTORY

bindkey -e
WORDCHARS=${WORDCHARS//[\/]}

typeset -U fpath path PATH
mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
fpath=(
  "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/site-functions"
  /opt/homebrew/share/zsh/site-functions
  $fpath
)

# Initialize tools before Zim's final interactive modules.
eval "$(zoxide init zsh)"
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(mise activate zsh)"

ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Install/update Zim's generated init script when needed, then load modules.
ZIM_HOME="${ZDOTDIR:-$HOME}/.zim"
if [[ ! -e "$ZIM_HOME/zimfw.zsh" ]]; then
  curl -fsSL --create-dirs -o "$ZIM_HOME/zimfw.zsh" \
    https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
fi
if [[ ! "$ZIM_HOME/init.zsh" -nt "${ZIM_CONFIG_FILE:-${ZDOTDIR:-$HOME}/.zimrc}" ]]; then
  source "$ZIM_HOME/zimfw.zsh" init -q
fi
source "$ZIM_HOME/init.zsh"

# Keep asciiship's prompt, but do not show the previous command's exit status.
PS1=${PS1//\%\(\?.%F\{green\}.%F\{red\}\%\? \)/}

# Search command history by the text already typed.
zmodload zsh/terminfo 2>/dev/null
[[ -n "${terminfo[kcuu1]}" ]] && bindkey "${terminfo[kcuu1]}" history-substring-search-up
[[ -n "${terminfo[kcud1]}" ]] && bindkey "${terminfo[kcud1]}" history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
