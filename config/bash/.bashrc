# options
shopt -s autocd
HISTSIZE=1000000

# aliases
alias ls="ls --color=auto"
alias grep="grep --color=auto"

# function for finding executables
function executable_find() {
    command -v $1 >/dev/null 2>&1
}

# prompt
CYAN="\e[36m"
MAGENTA="\e[35m"
YELLOW="\e[33m"
RESET="\e[0m"
PS1="$CYAN\u@\h $YELLOW\w"

# add git prompt if available
if executable_find __git_ps1; then
	PS1="$PS1$MAGENTA\$(__git_ps1)"
fi

PS1="$PS1$RESET $ "

# config based on availability of executables
executable_find direnv && eval "$(direnv hook bash)"

if executable_find fzf; then
    source <(fzf --bash)
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
