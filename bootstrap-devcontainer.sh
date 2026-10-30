#!/usr/bin/env bash
# Copies CLI dotfiles into a devcontainer. Run by DevPod:
#   devpod up . --dotfiles <url> --dotfiles-script bootstrap-devcontainer.sh
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# CLI configs only. Format: <stow package>:<path relative to $HOME>
PATHS=(
  nvim-k8s:.config/nvim-k8s
  starship:.config/starship.toml
  bat:.config/bat
  atuin:.config/atuin
  zsh:.zshrc
  tmux:.tmux.conf
)

echo "==> dotfiles source: $SRC"

for entry in "${PATHS[@]}"; do
  pkg="${entry%%:*}"; p="${entry#*:}"
  if [[ ! -e "$SRC/$pkg/$p" ]]; then
    echo "    skip    $p (not in repo)"
    continue
  fi

  # Back up whatever the image put there
  if [[ -e "$HOME/$p" && ! -L "$HOME/$p" ]]; then
    mkdir -p "$BACKUP/$(dirname "$p")"
    mv "$HOME/$p" "$BACKUP/$p"
    echo "    backup  $p"
  fi

  mkdir -p "$HOME/$(dirname "$p")"
  cp -r "$SRC/$pkg/$p" "$HOME/$p"
  echo "    install $p"
done

[[ -d "$BACKUP" ]] && echo "==> replaced files kept in $BACKUP"

# Ghostty terminfo (devpod ssh doesn't get Ghostty's ssh terminfo integration)
if [[ -f "$SRC/ghostty/xterm-ghostty.terminfo" ]] && command -v tic >/dev/null 2>&1; then
  tic -x "$SRC/ghostty/xterm-ghostty.terminfo" && echo "==> installed xterm-ghostty terminfo"
fi

# Debian puts zsh plugins in /usr/share/<name>/, not /usr/share/zsh/plugins/<name>/
if [[ -f "$HOME/.zshrc" ]]; then
  for n in zsh-autosuggestions zsh-syntax-highlighting; do
    if [[ -r "/usr/share/$n/$n.zsh" ]]; then
      sed -i "s#/usr/share/zsh/plugins/$n/$n.zsh#/usr/share/$n/$n.zsh#g" "$HOME/.zshrc"
      echo "    repath  $n -> /usr/share/$n/"
    else
      echo "    missing $n (not installed in this image)"
    fi
  done
fi

# Use the stripped nvim config
if [[ -d "$HOME/.config/nvim-k8s" ]]; then
  MARK="# devcontainer: stripped nvim config"
  if ! grep -qF "$MARK" "$HOME/.zshrc" 2>/dev/null; then
    printf '\n%s\nexport NVIM_APPNAME=nvim-k8s\n' "$MARK" >> "$HOME/.zshrc"
    echo "==> NVIM_APPNAME=nvim-k8s appended to .zshrc"
  fi
fi

# Debian names bat `batcat`
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  MARK_BAT="# devcontainer: bat is batcat on debian"
  if ! grep -qF "$MARK_BAT" "$HOME/.zshrc" 2>/dev/null; then
    printf '\n%s\nalias cat=batcat\n' "$MARK_BAT" >> "$HOME/.zshrc"
    echo "==> alias cat=batcat appended to .zshrc"
  fi
fi

# Make zsh the login shell if available
if command -v zsh >/dev/null 2>&1; then
  if [[ "${SHELL:-}" != *zsh ]] && command -v sudo >/dev/null 2>&1; then
    sudo chsh -s "$(command -v zsh)" "$(id -un)" && echo "==> login shell -> zsh"
  fi
else
  echo "==> zsh not installed; skipping chsh"
fi

# Report missing tools
missing=()
for c in nvim tmux zsh git atuin starship node npm kubectl helm; do
  command -v "$c" >/dev/null 2>&1 || missing+=("$c")
done
if ((${#missing[@]})); then
  echo "==> referenced by your config but NOT installed: ${missing[*]}"
fi

echo "==> done"
