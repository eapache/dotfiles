#!/bin/sh

cat ~/dotfiles/gitconfig >> ~/.gitconfig

echo ". ~/dotfiles/zshrc" >> ~/.zshrc

for FILE in gitignore vimrc
do
    ln -s ~/dotfiles/$FILE ~/.$FILE
done

mkdir -p ~/.vim/autoload
ln -s ~/dotfiles/plug.vim ~/.vim/autoload/plug.vim

# install vim plugins
vim -es -u ~/.vimrc -i NONE -c "PlugInstall" -c "qa"

exit 0
