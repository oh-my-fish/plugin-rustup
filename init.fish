set -l rustup_path  "$CARGO_HOME/bin"

contains -- $rustup_path $PATH
  or set -gx PATH $rustup_path $PATH
