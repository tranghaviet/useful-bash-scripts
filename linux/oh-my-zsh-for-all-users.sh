#!/bin/bash -e

echo "Install oh-my-zsh for all users"
echo "This script should install as sudoer user but not root"

echo "Installing zsh & oh-my-zsh"
sudo apt install zsh
sudo usermod --shell $(which zsh) $USER
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
sudo chown -R root:root .oh-my-zsh .zshrc
sudo chmod -R 755 .oh-my-zsh
sudo chmod 744 .zshrc

echo "Config .zshrc"
# echo "Auto load .bash_profile"
# echo "if [ -f ~/.bash_profile ]; then
#     . ~/.bash_profile;
# fi" >> ~/.zshrc

echo 'HIST_STAMPS="dd.mm.yyyy"' | sudo tee -a ~/.zshrc
echo "HISTSIZE=10000"  | sudo tee -a ~/.zshrc

echo "NOW=$(date +%Y-%m-%d_%H-%M-%S)" | sudo tee -a ~/.zshrc
echo "DATE=$(date +%Y-%m-%d)" | sudo tee -a ~/.zshrc

echo "switch $USER & root terminal to zsh"
sudo usermod --shell $(which zsh) root
sudo ln -s /home/$USER/.oh-my-zsh /root/
sudo ln -s /home/$USER/.zshrc /root/
