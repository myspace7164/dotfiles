# Configure $PATH
typeset -U path PATH
path=(~/.local/bin $path)
path=(~/.config/emacs/bin $path)
path=(/var/lib/flatpak/exports/bin $path)
export PATH

# Theming
export QT_QPA_PLATFORMTHEME=qt5ct:qt6ct
