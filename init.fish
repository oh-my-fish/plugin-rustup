set -l rustup_path  "$CARGO_HOME/.cargo/bin"

contains -- $rustup_path $PATH
  or set -gx PATH $rustup_path $PATH
