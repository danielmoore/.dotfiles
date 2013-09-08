#: ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

export PROFILE_DIR=%PROFILE_DIR%

source $PROFILE_DIR/dotfiles/bash/$(uname | tr '[A-Z]' '[a-z]').bashrc.bash
