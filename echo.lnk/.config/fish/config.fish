if status is-interactive
  zoxide init fish | source
  atuin init fish --disable-up-arrow | source

  function fish_greeting; end
else

end

