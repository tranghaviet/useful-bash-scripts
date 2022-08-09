#!/bin/bash -e

echo "Create a user and link to existing oh-my-zsh"

echo "Username to create:"
read username

echo "Username have oh-my-zsh:"
read targer_user

useradd -m -s $(which zsh) $username

TARGET_USER_HOME=$(eval echo ~$targer_user)

sudo -i -u $username bash << EOF
ln -s $TARGET_USER_HOME/.oh-my-zsh /home/$username
ln -s $TARGET_USER_HOME/.zshrc /home/$username
EOF

echo "Add user to sudo group? (y/n)"
read -e sudoer
if [ "$sudoer" == y ] ; then
usermod -aG sudo $username
fi

passwd $username
