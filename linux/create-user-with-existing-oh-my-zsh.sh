#!/bin/bash -e

echo "Create a user and link to existing oh-my-zsh"

echo "Username to create:"
read username

echo "Username have oh-my-zsh:"
read ohmyzsh_user

useradd -m -s $(which zsh) $username

sudo -i -u $username bash << EOF
ln -s /home/$ohmyzsh_user/.oh-my-zsh /home/$username
ln -s /home/$ohmyzsh_user/.zshrc /home/$username
EOF

echo "Add user to sudo group? (y/n)"
read -e sudoer
if [ "$sudoer" == y ] ; then
usermod -aG sudo $username
fi

passwd $username
