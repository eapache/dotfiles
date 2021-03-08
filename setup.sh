#!/bin/sh

# CONFIG FILES
cat ~/dotfiles/gitconfig >> ~/.gitconfig

echo ". ~/dotfiles/zshrc" >> ~/.zshrc

for FILE in gitignore vimrc tmux.conf
do
    ln -s ~/dotfiles/$FILE ~/.$FILE
done

tmux source-file ~/.tmux.conf

mkdir -p ~/.config/nvim
ln -s ~/dotfiles/init.vim ~/.config/nvim/init.vim

# INSTALL UTILS
sudo apt-get -y install ripgrep exuberant-ctags

# INSTALL VIM PLUGS
mkdir -p ~/.vim/autoload
ln -s ~/dotfiles/plug.vim ~/.vim/autoload/plug.vim
vim -es -u ~/.vimrc -i NONE -c "PlugInstall" -c "qa"

exit 0
