PATH="$HOME/.local/bin:$PATH"
PATH="/var/lib/flatpak/exports/bin:$PATH"
export PATH

[[ "$(tty)" = "/dev/tty1" ]] && exec sway
