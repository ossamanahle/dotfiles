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

# ── History search (atuin) ───────────────────────────────
# Binds ^R per-keymap (emacs/viins/vicmd), so it survives the `bindkey -v`
# below. Arrow keys are unbound in the key-bindings section.
eval "$(atuin init zsh --disable-up-arrow)"

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

# ── Key bindings (vi) ────────────────────────────────────
bindkey -v
export KEYTIMEOUT=1   # 10ms, else Esc lags ~0.4s waiting for an escape seq

# Word motions now live in normal mode: Esc, then w / b / e, 0 / $, and the
# usual operators (dw, ciw, f<char>). No Ctrl+arrow, no Alt+f/b.

# Arrow keys bound to a no-op in BOTH modes. Plain `bindkey -r` would be
# worse than useless here: the raw sequence (Esc [ A) would fall through as
# Esc then vicmd `A`, i.e. append-at-end-of-line. This makes them inert.
for _k in '^[[A' '^[[B' '^[[C' '^[[D'; do
  bindkey -M viins "$_k" undefined-key
  bindkey -M vicmd "$_k" undefined-key
done
unset _k

# Home / End / Delete keep working (not arrow keys, no habit to break).
for _m in viins vicmd; do
  bindkey -M $_m '^[[H' beginning-of-line
  bindkey -M $_m '^[[F' end-of-line
  bindkey -M $_m '^[[3~' delete-char
done
unset _m

# A few emacs keys kept in INSERT mode — vi mode drops these by default and
# they have no comfortable vim equivalent mid-typing.
bindkey -M viins '^?' backward-delete-char   # backspace past the insert point
# Ctrl+Backspace deletes the previous word. foot sends ^H (0x08) for it;
# ESC+DEL is bound too so this survives a terminal swap (kitty sent that).
# Emacs mode bound these by default, vi mode does not.
bindkey -M viins '^H' backward-kill-word
bindkey -M viins '^[^?' backward-kill-word
bindkey -M viins '^A' beginning-of-line
bindkey -M viins '^E' end-of-line
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line

# `v` in normal mode opens the current command line in $EDITOR (nvim).
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'v' edit-command-line

# Mode feedback: starship's vimcmd_symbol only updates if the prompt is
# redrawn on mode change, and the cursor shape makes the mode obvious.
# DECSCUSR: 2 = steady block, 4 = steady underline, 6 = steady beam.
_vi_cursor_insert() { printf '\e[4 q' }  # insert → underline
_vi_cursor_block()  { printf '\e[2 q' }  # normal → block (matches kitty.conf)
zle-keymap-select() {
  case $KEYMAP in
    vicmd)      _vi_cursor_block ;;
    viins|main) _vi_cursor_insert ;;
  esac
  zle reset-prompt
}
zle -N zle-keymap-select
autoload -Uz add-zsh-hook
_vi_cursor_default() { printf '\e[0 q' }  # hand control back to foot.ini
add-zsh-hook precmd _vi_cursor_insert     # every new prompt starts in insert
add-zsh-hook preexec _vi_cursor_default   # let programs pick their own cursor

# WORDCHARS includes '/' by default, so backward-kill-word (Ctrl+Backspace,
# Ctrl+W) would eat a whole path in one go. Drop '/' so it stops at one path
# segment. Only affects the ZLE word widgets, not vim's own w/b motions.
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
alias cat='bat'

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
bindkey -M viins '^[[Z' autosuggest-accept   # ^[[Z == Shift+Tab
bindkey -M vicmd '^[[Z' autosuggest-accept

# ── Prompt ───────────────────────────────────────────────
eval "$(starship init zsh)"
