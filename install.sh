#!/usr/bin/env bash

scriptdir=$(readlink -f $(dirname "$0"))

git pull $scriptdir
nix flake update --flake $scriptdir
sudo nixos-rebuild switch --flake $scriptdir

# reload sway
command -v swaymsg >/dev/null 2>&1 && swaymsg reload

command -v syncthing >/dev/null 2>&1 && syncthing device-id
