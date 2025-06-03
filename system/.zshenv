# Configure $PATH
typeset -U path PATH
path=(~/.local/bin $path)
path=(~/.config/emacs/bin $path)
path=(/var/lib/flatpak/exports/bin $path)
export PATH

# fzf
FD_EXCLUDE="--exclude .git --exclude compatdata"
export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow $FD_EXCLUDE"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"
export FZF_ALT_C_COMMAND="fd --type d --strip-cwd-prefix --hidden --follow $FD_EXCLUDE"
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

# Theming
export QT_QPA_PLATFORMTHEME=qt5ct:qt6ct
