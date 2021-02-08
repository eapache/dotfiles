#!/bin/sh

for FILE in gitconfig zshrc
do
    cat ~/dotfiles/$FILE >> ~/.$FILE
done

. ~/.zshrc

for FILE in gitignore vimrc
do
    ln -s ~/dotfiles/$FILE ~/.$FILE
done

mkdir -p ~/.vim/autoload
ln -s ~/dotfiles/plug.vim ~/.vim/autoload/plug.vim

# install plugins
vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
