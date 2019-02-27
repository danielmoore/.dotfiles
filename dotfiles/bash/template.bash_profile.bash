#!/bin/bash

export PROFILE_DIR=%PROFILE_DIR%

source $PROFILE_DIR/dotfiles/bash/$(uname | tr '[A-Z]' '[a-z]').bashrc.bash || \
source $PROFILE_DIR/dotfiles/bash/linux.bashrc.bash

source $PROFILE_DIR/dotfiles/bash/$(uname | tr '[A-Z]' '[a-z]').bash_profile.bash || \
source $PROFILE_DIR/dotfiles/bash/linux.bash_profile.bash
