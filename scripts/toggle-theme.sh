#!/usr/bin/env bash

current_state=$(cat ~/.local/state/theme)

if [[ $current_state == "dark" ]]; then
    echo "light" > ~/.local/state/theme
    emacsclient -e "(load-theme 'modus-operandi)"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-light"
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita"
    ln -sf ~/.local/share/themes/alacritty/modus_operandi.toml ~/.config/alacritty/current_theme.toml
else
    echo "dark" > ~/.local/state/theme
    emacsclient -e "(load-theme 'modus-vivendi)"
    gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"
    gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
    ln -sf ~/.local/share/themes/alacritty/modus_vivendi.toml ~/.config/alacritty/current_theme.toml
fi

touch -h ~/.config/alacritty/alacritty.toml
