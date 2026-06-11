#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias dotfiles='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
export PATH="$HOME/.local/bin:$PATH"

# Starship prompt
eval "$(starship init bash)"
