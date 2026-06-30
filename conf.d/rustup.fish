set -l cargo_bin $HOME/.cargo/bin

if [ $CARGO_HOME ]
  set cargo_bin $CARGO_HOME/bin
end

set -l keg_bin

if type -q brew
  set -l brew_prefix (brew --prefix rustup 2>/dev/null)
  if test -n "$brew_prefix" -a -d "$brew_prefix/bin"
    set keg_bin "$brew_prefix/bin"
  end
end

contains -- $cargo_bin $PATH
  or set -gx PATH $cargo_bin $PATH

if test -n "$keg_bin"
  contains -- $keg_bin $PATH
    or set -gx PATH $keg_bin $PATH
end
