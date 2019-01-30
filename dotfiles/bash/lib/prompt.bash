#!/bin/bash

if [[ -n "$POWERLINE_ROOT" ]]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source "$POWERLINE_ROOT/bindings/bash/powerline.sh"
else
  # this depends on ./git.bash being sourced already.

  env=$(cat ~/.env 2>/dev/null)

  case $env in
    qa)       hostColor='01;33'    ;; # bold yellow
    uat)      hostColor='01;33'    ;; # bold yellow
    prod)     hostColor='41;01;97' ;; # bg-red, bold white
    *)        hostColor='01;32'    ;; # bold green
  esac

  export PROMPT_COMMAND=$'__git_ps1 \'\e[${hostColor}m\u@\h\e[0m \xE2\x96\xB8 \e[00;34m\w\e[0m\' \'\n\! \$ \' \' %s\''
fi
