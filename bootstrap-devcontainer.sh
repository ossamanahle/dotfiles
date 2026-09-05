#!/usr/bin/env bash
# Dotfiles setup for a devcontainer — NOT a machine provisioner.
#
# Run by DevPod after it clones this repo:
#   devpod up . --dotfiles <url> --dotfiles-script bootstrap-devcontainer.sh
#
# Assumptions (all differ from bootstrap.sh, which provisions an Arch laptop):
#   - runs as the container's remoteUser, $HOME is that user's home
#   - this repo is ALREADY cloned; no network fetch of dotfiles needed
#   - no pacman, no AUR, no systemd, no display server
#   - non-interactive: no prompts, no password
set -euo pipefail

# Where this script lives == the clone DevPod made.
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Only the configs that mean something without a GUI.
# Deliberately excluded: hypr, waybar, mako, kitty, alacritty, foot, gtk —
# a container has no compositor, no window, no font rendering.
PATHS=(
  .config/nvim
  .config/starship.toml
  .config/bat
  .config/atuin
  .config/yazi
  .zshrc
)

echo "==> dotfiles source: $SRC"

for p in "${PATHS[@]}"; do
  if [[ ! -e "$SRC/$p" ]]; then
    echo "    skip    $p (not in repo)"
    continue
  fi

  # Preserve anything the image put there (e.g. a default .zshrc).
  if [[ -e "$HOME/$p" && ! -L "$HOME/$p" ]]; then
    mkdir -p "$BACKUP/$(dirname "$p")"
    mv "$HOME/$p" "$BACKUP/$p"
    echo "    backup  $p"
  fi

  mkdir -p "$HOME/$(dirname "$p")"
  cp -r "$SRC/$p" "$HOME/$p"
  echo "    install $p"
done

[[ -d "$BACKUP" ]] && echo "==> replaced files kept in $BACKUP"

# zsh as the login shell, if the image has it. chsh needs no password
# under sudo NOPASSWD; skip silently when either piece is missing.
if command -v zsh >/dev/null 2>&1; then
  if [[ "${SHELL:-}" != *zsh ]] && command -v sudo >/dev/null 2>&1; then
    sudo chsh -s "$(command -v zsh)" "$(id -un)" && echo "==> login shell -> zsh"
  fi
else
  echo "==> zsh not installed; skipping chsh"
fi

# Report what .zshrc expects but the image lacks, instead of failing later
# at every shell start.
missing=()
for c in nvim tmux zsh git atuin starship bat; do
  command -v "$c" >/dev/null 2>&1 || missing+=("$c")
done
if ((${#missing[@]})); then
  echo "==> referenced by your config but NOT installed: ${missing[*]}"
fi

echo "==> done"
