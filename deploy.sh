#!/bin/bash

DIR=$(dirname $0)

mv .bashrc .bashrc.old
ln -s $DIR/bash/bashrc.osx ~/.bashrc

mv .vimrc .vimrc.old
ln -s $DIR/vim/vimrc.cli ~/.vimrc

mv .vim .vim.old
ln -s $DIR/vim/vimfiles ~/.vim
