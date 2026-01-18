if status is-interactive
  zoxide init fish | source
  atuin init fish --disable-up-arrow | source

  # set -gx http_proxy http://127.0.0.1:6152
  # set -gx https_proxy http://127.0.0.1:6152
  # set -gx all_proxy socks5://127.0.0.1:6153

  set -x GOPATH $HOME/.local/go
  set -x GOBIN  $GOPATH/bin
  set -x GOCACHE $HOME/.cache/go

  set -x HOMEBREW_BREW_GIT_REMOTE https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git
  set -x HOMEBREW_API_DOMAIN https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api
  set -x HOMEBREW_BOTTLE_DOMAIN https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

  alias tailscale='/Applications/Tailscale.app/Contents/MacOS/Tailscale'

  function fish_greeting; end
else

end

