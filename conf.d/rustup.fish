set -l rustup_path

if type -q brew
  set -l brew_prefix (brew --prefix rustup 2>/dev/null)
  if test -n "$brew_prefix" -a -d "$brew_prefix/bin"
    set rustup_path "$brew_prefix/bin"
  end
end

if test -z "$rustup_path"
  set rustup_path $HOME/.cargo/bin
  if [ $CARGO_HOME ]
    set rustup_path $CARGO_HOME/bin
  end
end

contains -- $rustup_path $PATH
  or set -gx PATH $rustup_path $PATH
