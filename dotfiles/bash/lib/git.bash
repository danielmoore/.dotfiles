#!/bin/bash

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWUPSTREAM="auto verbose"
export GIT_PS1_SHOWCOLORHINTS=false

gitRootDir=$(dirname $(git --info-path))/..

source $(find $gitRootDir -name git-completion.bash)
source $(find $gitRootDir -name git-prompt.sh)
