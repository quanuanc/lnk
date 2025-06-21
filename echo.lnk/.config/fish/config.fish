if status is-interactive
  zoxide init fish | source
  atuin init fish --disable-up-arrow | source

  set -gx http_proxy http://127.0.0.1:6154
  set -gx https_proxy http://127.0.0.1:6154
  set -gx all_proxy socks5://127.0.0.1:6155

  function fish_greeting; end
else

end

