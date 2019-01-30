#!/bin/bash

#export XDG_CONFIG_DIRS=$PROFILE_DIR
export POWERLINE_CONFIG_PATHS="$PROFILE_DIR/powerline"
export POWERLINE_ROOT="$(pip3 show powerline-status | grep -e '^Location:' | cut -f2 -d ' ')/powerline"

source $PROFILE_DIR/dotfiles/bash/lib/index.bash
source $PROFILE_DIR/dotfiles/bash/aliases/darwin.bash

launchctl setenv PATH "$PATH"
