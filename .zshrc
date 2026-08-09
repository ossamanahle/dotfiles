# ~/.zshrc

# ── History ──────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY          # share history across sessions
setopt HIST_IGNORE_ALL_DUPS   # no duplicate entries
setopt HIST_IGNORE_SPACE      # ignore commands starting with a space
setopt HIST_REDUCE_BLANKS
setopt EXTENDED_HISTORY       # timestamp entries

# ── Directory & navigation ───────────────────────────────
setopt AUTO_CD                # `foo` == `cd foo`
setopt AUTO_PUSHD             # cd pushes onto dir stack
setopt PUSHD_IGNORE_DUPS

# ── Completion ───────────────────────────────────────────
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select                        # arrow-key menu
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'    # case-insensitive
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}     # colorized
setopt COMPLETE_IN_WORD

# ── Key bindings (emacs) ─────────────────────────────────
bindkey -e
bindkey '^[[A' history-search-backward   # ↑ search by typed prefix
bindkey '^[[B' history-search-forward    # ↓
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[[1;5C' forward-word           # Ctrl+Right
bindkey '^[[1;5D' backward-word          # Ctrl+Left

# Ctrl+Backspace (kitty.conf sends ESC+DEL) is already bound to
# backward-kill-word, but WORDCHARS includes '/' by default, so it deletes
# a whole path in one go. Drop '/' so it stops at one path segment/word.
WORDCHARS=${WORDCHARS//[\/]}

# ── Environment ──────────────────────────────────────────
export MANPAGER='nvim +Man!'
export GOROOT=/usr/local/go
export GOPATH=$HOME/go

export PATH="$HOME/.local/bin:$GOPATH/bin:$GOROOT/bin:$HOME/.local/bin:$PATH"

# ── Aliases (carried from .bashrc) ───────────────────────
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias vim='nvim'
alias sls='npx serverless'
alias dotfiles='git --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'

# ── Functions ────────────────────────────────────────────
# Switch wallpaper (swaybg): setwall <image-path>
setwall() { pkill swaybg; swaybg -i "$1" -m fill >/dev/null 2>&1 & disown; echo "$1" > ~/.cache/wallpaper; }

# ── Plugins ──────────────────────────────────────────────
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# Syntax highlighting — MUST be sourced last.
# Colors the command line live: valid commands = green, bad = red.
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
# green when the command exists / is valid:
ZSH_HIGHLIGHT_STYLES[command]='fg=green'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=green'
ZSH_HIGHLIGHT_STYLES[function]='fg=green'
ZSH_HIGHLIGHT_STYLES[alias]='fg=green'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green'      # sudo, command, etc.
# red when it's not a real command:
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[commandseparator]='fg=default'

# Shift+Tab accepts the autosuggestion (Tab stays normal completion).
bindkey '^[[Z' autosuggest-accept   # ^[[Z == Shift+Tab

# ── Prompt ───────────────────────────────────────────────
eval "$(starship init zsh)"
