setopt autocd extendedglob
unsetopt beep

bindkey -e
bindkey "^[[3~" delete-char

autoload -Uz compinit && compinit
zstyle :compinstall filename '/home/user/.zshrc'

autoload -U select-word-style && select-word-style bash

HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

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

alias ls="ls --color=auto"
alias grep="grep --color=auto"

executable_find() {
    command -v $1 >/dev/null 2>&1
}

executable_find direnv && eval "$(direnv hook zsh)"

if executable_find fzf; then
    source <(fzf --zsh)
    export FZF_DEFAULT_COMMAND="fd --hidden --follow --strip-cwd-prefix --exclude .git --exclude compatdata"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND --type f"
    export FZF_ALT_C_COMMAND="$FZF_DEFAULT_COMMAND --type d"
    export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {}'"
    export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"
fi

if executable_find lazygit; then
	function lg() {
    export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
            cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
            rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
	}
fi

if executable_find nvim; then
    export EDITOR="nvim"
    export VISUAL="nvim"
    export MANPAGER="nvim +Man!"
    alias vim="nvim"
    alias vi="nvim"
else
    # If neovim is not installed color the man pages
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
fi

if executable_find yazi; then
	function y() {
	    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	    yazi "$@" --cwd-file="$tmp"
	    IFS= read -r -d '' cwd < "$tmp"
	    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	    rm -f -- "$tmp"
    }
fi
