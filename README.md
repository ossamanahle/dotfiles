# dotfiles

Managed with GNU Stow. Each top-level directory is a package mirroring `$HOME`.

```sh
cd ~/dotfiles
stow */            # link everything
stow nvim zsh      # or pick packages
stow -D nvim       # unlink
stow --adopt pkg   # pull existing files in $HOME into the repo, then `git diff`
```

`bootstrap-devcontainer.sh` copies a CLI-only subset for DevPod containers.
