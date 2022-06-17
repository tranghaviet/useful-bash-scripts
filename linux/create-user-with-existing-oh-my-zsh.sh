#!/bin/bash -e

echo "Create a user and link to existing oh-my-zsh"

echo "Username to create:"
read username

echo "Username have oh-my-zsh:"
read target_user

useradd -m -s $(which zsh) $username

ln -s /home/$target_user/.oh-my-zsh /home/$username
ln -s /home/$target_user/.zshrc /home/$username

chown $username:$username /home/$username/.zshrc
chown $username:$username /home/$username/.oh-my-zsh

echo "You should set user password by running: passwd $username"
