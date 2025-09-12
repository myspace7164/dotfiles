#!/usr/bin/env bash

current_state=$(cat ~/.local/state/theme)

if [[ $current_state == "dark" ]]; then
    echo "light" > ~/.local/state/theme
    emacsclient -e "(load-theme 'modus-operandi)"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
else
    echo "dark" > ~/.local/state/theme
    emacsclient -e "(load-theme 'modus-vivendi)"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
fi
