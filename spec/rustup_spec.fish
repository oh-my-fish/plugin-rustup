set -g __rustup_spec_plugin (command dirname (command dirname (status -f)))/conf.d/rustup.fish

function describe_rustup_plugin
  function before_each
    set -g __saved_path $PATH
    set -g __saved_cargo_home $CARGO_HOME
    set -e CARGO_HOME
    set -g __tmp_brew (command mktemp -d)
    set -g __tmp_prefix (command mktemp -d)
    set -gx PATH /usr/bin /bin
  end

  function after_each
    set -gx PATH $__saved_path
    if test -n "$__saved_cargo_home"
      set -gx CARGO_HOME $__saved_cargo_home
    else
      set -e CARGO_HOME
    end
    command rm -rf $__tmp_brew $__tmp_prefix
    set -e __saved_path __saved_cargo_home __tmp_brew __tmp_prefix
  end

  function it_prepends_cargo_bin_when_no_brew_is_available
    source $__rustup_spec_plugin
    assert_equal $HOME/.cargo/bin $PATH[1]
  end

  function it_uses_CARGO_HOME_when_set
    set -gx CARGO_HOME /tmp/custom-cargo
    source $__rustup_spec_plugin
    assert_equal /tmp/custom-cargo/bin $PATH[1]
  end

  function it_prepends_brew_keg_when_rustup_formula_is_installed
    command mkdir -p $__tmp_prefix/bin
    printf '%s\n%s\n' '#!/bin/sh' "echo $__tmp_prefix" > $__tmp_brew/brew
    command chmod +x $__tmp_brew/brew
    set -gx PATH $__tmp_brew $PATH
    source $__rustup_spec_plugin
    assert_equal $__tmp_prefix/bin $PATH[1]
    assert_in_array $HOME/.cargo/bin $PATH
  end

  function it_skips_brew_keg_when_rustup_formula_is_absent
    printf '%s\n%s\n' '#!/bin/sh' 'exit 1' > $__tmp_brew/brew
    command chmod +x $__tmp_brew/brew
    set -gx PATH $__tmp_brew $PATH
    source $__rustup_spec_plugin
    assert_not_in_array $__tmp_prefix/bin $PATH
    assert_in_array $HOME/.cargo/bin $PATH
  end

  function it_skips_brew_keg_when_prefix_bin_does_not_exist
    printf '%s\n%s\n' '#!/bin/sh' "echo $__tmp_prefix" > $__tmp_brew/brew
    command chmod +x $__tmp_brew/brew
    set -gx PATH $__tmp_brew $PATH
    source $__rustup_spec_plugin
    assert_not_in_array $__tmp_prefix/bin $PATH
    assert_in_array $HOME/.cargo/bin $PATH
  end

  function it_does_not_duplicate_entries_when_resourced
    source $__rustup_spec_plugin
    set -l count_first (count $PATH)
    source $__rustup_spec_plugin
    assert_equal $count_first (count $PATH)
  end
end
