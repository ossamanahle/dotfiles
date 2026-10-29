[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
export PATH="$HOME/.local/bin:$PATH"
export MANPAGER='nvim +Man!'

eval "$(starship init bash)"

alias sls='npx serverless'
alias vim='nvim'

setwall() { pkill swaybg; swaybg -i "$1" -m fill >/dev/null 2>&1 & disown; }
