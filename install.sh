#!/usr/bin/env bash

scriptdir=$(readlink -f $(dirname "$0"))

nix flake update --flake $scriptdir
sudo nixos-rebuild switch --flake $scriptdir

# reload sway
command -v swaymsg >/dev/null 2>&1 && swaymsg reload

# If default ssh key does not exist, generate one and print it
[[ ! -f $HOME/.ssh/id_rsa ]] && ssh-keygen -t rsa -b 4096 -f $HOME/.ssh/id_rsa -N ""
cat $HOME/.ssh/id_rsa.pub

command -v syncthing >/dev/null 2>&1 && syncthing device-id
