#!/bin/bash -e

echo "Install oh-my-zsh for all users"
echo "This script should install as sudoer user but not root"

echo "Installing zsh & oh-my-zsh"
apt install zsh
cd ~
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chown -R root:root .oh-my-zsh .zshrc
chmod -R 755 .oh-my-zsh
chmod 744 .zshrc

echo "Config .zshrc"
echo "Auto load .bash_profile"
echo "if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile;
fi" >> ~/.zshrc

echo 'HIST_STAMPS="dd.mm.yyyy"' >> ~/.zshrc
echo "HISTSIZE=10000" >> ~/.zshrc

echo "NOW=$(date +%Y-%m-%d_%H-%M-%S)" >> ~/.zshrc
echo "DATE=$(date +%Y-%m-%d)" >> ~/.zshrc

echo "switch $USER & root terminal to zsh"
usermod --shell $(which zsh) $USER
usermod --shell $(which zsh) root
ln -s /home/$USER/.oh-my-zsh /root/
ln -s /home/$USER/.zshrc /root/
