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

# install vim plugins
vim -es -u ~/.vimrc -i NONE -c "PlugInstall" -c "qa"

exit 0
