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
  .config/nvim-k8s
  .config/starship.toml
  .config/bat
  .config/atuin
  .zshrc
  .tmux.conf
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

# zsh plugin paths: .zshrc hardcodes Arch's layout
#   /usr/share/zsh/plugins/<name>/<name>.zsh
# Debian installs to
#   /usr/share/<name>/<name>.zsh
# The sources are suppressed with 2>/dev/null, so a wrong path fails silently
# and ZSH_HIGHLIGHT_STYLES is never declared as an associative array -- the
# next line then errors with "assignment to invalid subscript range".
#
# Rewrite the paths in the COPY, in place: these lines run near the top of
# .zshrc, so appending a fix at the end would be too late.
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

# Select the stripped nvim config. NVIM_APPNAME makes nvim read
# ~/.config/nvim-k8s instead of ~/.config/nvim. Container-only: this line is
# appended here rather than committed to .zshrc, so the laptop is unaffected.
if [[ -d "$HOME/.config/nvim-k8s" ]]; then
  MARK="# devcontainer: stripped nvim config"
  if ! grep -qF "$MARK" "$HOME/.zshrc" 2>/dev/null; then
    printf '\n%s\nexport NVIM_APPNAME=nvim-k8s\n' "$MARK" >> "$HOME/.zshrc"
    echo "==> NVIM_APPNAME=nvim-k8s appended to .zshrc"
  fi
fi

# Debian ships bat's binary as `batcat` (name clash with bacula-console-qt);
# Arch ships it as `bat`. .zshrc aliases cat='bat', which breaks here.
# Appending works because the LAST alias definition wins -- unlike the plugin
# `source` lines above, which had to be fixed in place.
if ! command -v bat >/dev/null 2>&1 && command -v batcat >/dev/null 2>&1; then
  MARK_BAT="# devcontainer: bat is batcat on debian"
  if ! grep -qF "$MARK_BAT" "$HOME/.zshrc" 2>/dev/null; then
    printf '\n%s\nalias cat=batcat\n' "$MARK_BAT" >> "$HOME/.zshrc"
    echo "==> alias cat=batcat appended to .zshrc"
  fi
fi

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
for c in nvim tmux zsh git atuin starship node npm kubectl helm; do
  command -v "$c" >/dev/null 2>&1 || missing+=("$c")
done
if ((${#missing[@]})); then
  echo "==> referenced by your config but NOT installed: ${missing[*]}"
fi

echo "==> done"
