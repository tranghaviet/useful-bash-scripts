#!/bin/bash -e

echo "Install oh-my-zsh for all users"
echo "This script should install as root user"
echo "Need at least a normal username"

echo "Username:"
read username

apt install zsh
cd /home/$username
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
chown -R root:root .oh-my-zsh .zshrc
chmod -R 755 .oh-my-zsh
chmod 744 .zshrc

# switch terminal to zsh
usermod --shell $(which zsh) $username
usermod --shell $(which zsh) root
ln -s /home/$username/.oh-my-zsh /root/
ln -s /home/$username/.zshrc /root/
