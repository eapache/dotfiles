#!/bin/sh

for FILE in gitconfig zshrc
do
    cat ~/dotfiles/$FILE >> ~/.$FILE
done

for FILE in gitignore vimrc
do
    cat ~/dotfiles/$FILE >> ~/.$FILE
done

mkdir -p ~/.vim/autoload
ln -s ~/dotfiles/plug.vim ~/.vim/autoload/plug.vim

vim -es -i NONE -c "PlugInstall" -c "q"

exit 0
