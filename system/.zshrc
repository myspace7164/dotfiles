setopt autocd extendedglob
unsetopt beep

bindkey -e
bindkey "^[[3~" delete-char

autoload -Uz compinit
compinit
zstyle :compinstall filename '/home/user/.zshrc'

autoload -U select-word-style
select-word-style bash

# History
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000000

# Alias
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim='nvim'

# Prompt
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git hg svn

zstyle ':vcs_info:git:*' formats '%F{green}git:(%b)%f'
zstyle ':vcs_info:hg:*' formats '%F{magenta}hg:(%b)%f'
zstyle ':vcs_info:svn:*' formats '%F{yellow}svn:r%r%f'

zstyle ':vcs_info:git:*' actionformats '%F{red}git[%a]%f'

precmd() { vcs_info }

setopt prompt_subst
PROMPT='%F{cyan}%n@%m%f:%F{yellow}%~%f ${vcs_info_msg_0_}%(!.#.>) '

# Color man pages
man() {
	env \
		LESS_TERMCAP_md=$(tput bold; tput setaf 4) \
		LESS_TERMCAP_me=$(tput sgr0) \
		LESS_TERMCAP_mb=$(tput blink) \
		LESS_TERMCAP_us=$(tput setaf 2) \
		LESS_TERMCAP_ue=$(tput sgr0) \
		LESS_TERMCAP_so=$(tput smso) \
		LESS_TERMCAP_se=$(tput rmso) \
		man "$@"
}
export GROFF_NO_SGR=1

# Based on the distro, some plugin loading is handled by the distro itself (namely NixOS)
distro=$(awk -F= '/^ID=/{print $2}' /etc/os-release | tr -d '"')

# fzf
[ $distro != nixos ] && command -v fzf >/dev/null 2>&1 && source <(fzf --zsh)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if command -v fd > /dev/null 2>&1; then
  fd_cmd='fd'
elif command -v fdfind > /dev/null 2>&1; then
  fd_cmd='fdfind'
else
  fd_cmd='find . -type f'
fi

FD_EXCLUDE="--exclude .git --exclude compatdata"
export FZF_DEFAULT_COMMAND="$fd_cmd --type f --strip-cwd-prefix --hidden --follow $FD_EXCLUDE"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"
export FZF_ALT_C_COMMAND="$fd_cmd --type d --strip-cwd-prefix --hidden --follow $FD_EXCLUDE"
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

# direnv
[ $distro != nixos ] && command -v direnv >/dev/null 2>&1 && eval "$(direnv hook zsh)"

# Auto suggestions
if [[ -f "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
elif [[ -f "/usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# Syntax highlighting
if [[ -f "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
