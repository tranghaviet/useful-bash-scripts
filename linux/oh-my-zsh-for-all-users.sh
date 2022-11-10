#!/bin/bash -e

echo "Install oh-my-zsh for all users"
echo "This script should install as sudoer user but not root"

echo "Installing zsh & oh-my-zsh"
sudo apt install zsh -y
sudo usermod --shell $(which zsh) $USER
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)" "" --unattended

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

sudo chown -R root:root .oh-my-zsh .zshrc
sudo chmod -R 755 .oh-my-zsh
sudo chmod 744 .zshrc

echo "Config .zshrc"
# echo "Auto load .bash_profile"
# echo "if [ -f ~/.bash_profile ]; then
#     . ~/.bash_profile;
# fi" >> ~/.zshrc
sudo sed -i "s/robbyrussell/fletcherm/" ~/.zshrc
sudo sed -i "s/(git)/(git z zsh-autosuggestions zsh-completions zsh-syntax-highlighting)/" ~/.zshrc
sudo sed -i 's/# DISABLE_AUTO_TITLE="true"/DISABLE_AUTO_TITLE="true"/' ~/.zshrc
# sudo sed -i 's/# ENABLE_CORRECTION="false"/ENABLE_CORRECTION="true"/' ~/.zshrc

echo 'HIST_STAMPS="dd.mm.yyyy"' | sudo tee -a ~/.zshrc
echo "HISTSIZE=10000" | sudo tee -a ~/.zshrc

echo "NOW=\$(date +%Y-%m-%d_%H-%M-%S)" | sudo tee -a ~/.zshrc
echo "DATE=\$(date +%Y-%m-%d)" | sudo tee -a ~/.zshrc

echo "switch $USER & root terminal to zsh"
sudo usermod --shell $(which zsh) root
sudo ln -s $(eval echo ~$USER)/.oh-my-zsh /root/
sudo ln -s $(eval echo ~$USER)/.zshrc /root/

zsh
