# Configure $PATH
typeset -U path PATH
path=(~/.local/bin $path)
path=(/var/lib/flatpak/exports/bin $path)
export PATH
