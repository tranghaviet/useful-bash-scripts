#!/bin/bash -e

echo "Create a user with oh-my-zsh"

echo "Username to create:"
read username

sudo useradd -m -s $(which zsh) $username

echo "Add user to sudo group? (y/n)"
  read -e sudoer
if [ "$sudoer" == y ] ; then
  sudo usermod -aG sudo $username
fi

echo "Password for user:"
sudo passwd $username
