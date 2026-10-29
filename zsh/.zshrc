# History
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY

# Atuin binds ^R per keymap, so it survives `bindkey -v`
eval "$(atuin init zsh --disable-up-arrow)"
eval "$(direnv hook zsh)"

# Navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# Completion
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
setopt COMPLETE_IN_WORD

# Vi mode
bindkey -v
export KEYTIMEOUT=1  # no Esc lag

# Disable arrow keys (bindkey -r would leak Esc+A into vicmd)
for _k in '^[[A' '^[[B' '^[[C' '^[[D'; do
  bindkey -M viins "$_k" undefined-key
  bindkey -M vicmd "$_k" undefined-key
done
unset _k

for _m in viins vicmd; do
  bindkey -M $_m '^[[H' beginning-of-line
  bindkey -M $_m '^[[F' end-of-line
  bindkey -M $_m '^[[3~' delete-char
done
unset _m

# Keep a few emacs keys in insert mode
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line

# v in normal mode edits the command in nvim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Cursor shape per mode (underline = insert, block = normal)
_vi_cursor_insert() { printf '\e[4 q' }
_vi_cursor_block()  { printf '\e[2 q' }
zle-keymap-select() {
  case $KEYMAP in
    vicmd)      _vi_cursor_block ;;
    viins|main) _vi_cursor_insert ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select
autoload -Uz add-zsh-hook
_vi_cursor_default() { printf '\e[0 q' }
add-zsh-hook precmd _vi_cursor_insert
add-zsh-hook preexec _vi_cursor_default

# Ctrl+W stops at /
WORDCHARS=${WORDCHARS//[\/]}

# Environment
export MANPAGER='nvim +Man!'
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GPG_TTY=$(tty)

export PATH="$HOME/.local/bin:$GOPATH/bin:$GOROOT/bin:$PATH"

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim='nvim'
alias sls='npx serverless'
alias cat='bat'
alias op='opencode'

# setwall <image>
setwall() { pkill swaybg; swaybg -i "$1" -m fill >/dev/null 2>&1 & disown; echo "$1" > ~/.cache/wallpaper; }

# Plugins
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# Syntax highlighting (plugin loaded by NixOS)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'
ZSH_HIGHLIGHT_STYLES[function]='fg=green'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'

ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=default'

# Shift+Tab accepts the suggestion
bindkey -M viins '^[[Z' autosuggest-accept
bindkey -M vicmd '^[[Z' autosuggest-accept

# Prompt
eval "$(starship init zsh)"
