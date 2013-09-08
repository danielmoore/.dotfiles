#!/bin/bash

source $PROFILE_DIR/dotfiles/bash/lib/index.bash
source $PROFILE_DIR/dotfiles/bash/aliases/linux.bash

if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='ls --color=auto --format=vertical'
    #alias vdir='ls --color=auto --format=long'
fi
