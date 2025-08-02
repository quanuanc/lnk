function proxy
  set -gx http_proxy http://127.0.0.1:6155
  set -gx https_proxy http://127.0.0.1:6155
  set -gx all_proxy socks5://127.0.0.1:6155
end
