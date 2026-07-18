#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias dotfiles='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
export PATH="$HOME/.local/bin:$PATH"
export MANPAGER='nvim +Man!'

# Starship prompt
eval "$(starship init bash)"

# serverless
alias sls='npx serverless'
alias vim='nvim'

# Switch wallpaper (swaybg): setwall <image-path>
setwall() { pkill swaybg; swaybg -i "$1" -m fill >/dev/null 2>&1 & disown; }
