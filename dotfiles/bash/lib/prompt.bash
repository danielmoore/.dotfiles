#!/bin/bash

source $PROFILE_DIR/dotfiles/bash/lib/git-prompt.sh

env=$(cat ~/.env 2>/dev/null)

case $env in
  qa)                            ;&
  uat)      hostColor='01;33'    ;; # bold yellow
  prod)     hostColor='41;01;97' ;; # bg-red, bold white
  *)        hostColor='01;32'    ;; # bold green
esac

export PROMPT_COMMAND='__git_ps1 "\e[${hostColor}m\u@\h\e[0m\]: \e[00;34m\]\w\e[00m\]" "\n\! \$ " " %s"'
