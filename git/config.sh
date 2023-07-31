#!/bin/bash -e

# user
read -p "Global user name: " GIT_USER
git config --global user.email $GIT_USER

read -p "Global user email: " GIT_EMAIL
git config --global user.name $GIT_EMAIL

# store credential
git config --global credential.helper store

# Push
git config --global push.default current

# Pull & diff
# https://spin.atomicobject.com/2020/05/05/git-configurations-default/
git config --global pull.rebase true
git config --global fetch.prune true
git config --global diff.colorMoved zebra

# editor
git config --global core.editor "vim"

# log one line
git config --global alias.lg "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
# usage: git lg
