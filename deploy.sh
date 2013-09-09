#!/bin/bash

dir=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

echo Setting \$PROFILE_DIR to $dir

function install {
  mv ~/$2 ~/$2.old
  cat $dir/$1 | sed "s/%PROFILE_DIR%/$(sed -e 's/[\/&]/\\&/g' <<< $dir)/g" > ~/$2
}

function link {
  mv ~/$2 ~/$2.old
  ln -s $dir/$1 ~/$2
}

install dotfiles/bash/template.bashrc.bash .bashrc
install dotfiles/bash/template.bash_profile.bash .bash_profile

install dotfiles/template.gitconfig .gitconfig

link dotfiles/vim/vimrc.cli .vimrc
link dotfiles/vim/vimfiles .vim
