#!/usr/bin/env bash
#######################################################################
#           THYING THIS SCRIP I COPYED FROM THE HUB                   #
#######################################################################
rm -rf zsh 
sudo apt install stow -y
sudo apt install zsh -y

pushd $DOTFILES
for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g")
do
    stow -D $folder
    stow $folder
done
popd





#if [[ -z $STOW_FOLDERS ]]; then
 #   STOW_FOLDERS="bin,i3,nvim,tmux,zsh"
#fi

#if [[ -z $DOTFILES ]]; then
 #   DOTFILES=$HOME/.config/.dotfiles
#fi

#STOW_FOLDERS=$STOW_FOLDERS DOTFILES=$DOTFILES $DOTFILES/install
