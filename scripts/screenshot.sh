#!/usr/bin/env bash

grim -g "$(swaymsg -t get_tree | jq -r '.. | select(.pid? and .visible?) | "\(.rect.x+.window_rect.x),\(.rect.y+.window_rect.y) \(.window_rect.width)x\(.window_rect.height)"' | slurp)" - | tee "$(xdg-user-dir PICTURES)/$(date +%Y%m%d_%Hh%Mm%Ss)_grim.png" | wl-copy
