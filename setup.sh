#!/bin/sh

# CONFIG FILES
cat ~/dotfiles/gitconfig >> ~/.gitconfig

echo ". ~/dotfiles/zshrc" >> ~/.zshrc

for FILE in gitignore vimrc
do
    ln -s ~/dotfiles/$FILE ~/.$FILE
done

# INSTALL UTILS
sudo apt-get install fzf ripgrep

# INSTALL VIM PLUGS
mkdir -p ~/.vim/autoload
ln -s ~/dotfiles/plug.vim ~/.vim/autoload/plug.vim
vim -es -u ~/.vimrc -i NONE -c "PlugInstall" -c "qa"

exit 0
