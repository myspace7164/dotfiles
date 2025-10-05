setopt autocd extendedglob
unsetopt beep

bindkey -e
bindkey "^[[3~" delete-char

autoload -Uz compinit && compinit
zstyle :compinstall filename '/home/user/.zshrc'

autoload -U select-word-style && select-word-style bash

export MANPAGER="nvim +Man!"

export FZF_DEFAULT_COMMAND="fd --hidden --follow --strip-cwd-prefix --exclude .git --exclude compatdata"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type f"
export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

alias ls="ls --almost-all --color=auto"
alias grep="grep --color=auto"
