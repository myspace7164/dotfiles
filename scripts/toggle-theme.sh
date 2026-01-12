#!/usr/bin/env bash

current_state=$(cat ~/.local/state/theme)

if [[ $current_state == "dark" ]]; then
    echo "light" > ~/.local/state/theme
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    pkill -u "$USER" --signal=SIGUSR2 ^foot$
    sed -i 's/initial-color-theme=[0-9]*/initial-color-theme=2/' ~/.config/foot/color-theme.ini
else
    echo "dark" > ~/.local/state/theme
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    pkill -u "$USER" --signal=SIGUSR1 ^foot$
    sed -i 's/initial-color-theme=[0-9]*/initial-color-theme=1/' ~/.config/foot/color-theme.ini
fi
