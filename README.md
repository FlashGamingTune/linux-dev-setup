# Linux Dev Setup

A small, repeatable terminal setup designed to work across Linux distributions.

## Install

```bash
git clone https://github.com/FlashGamingTune/linux-dev-setup.git
cd linux-dev-setup
./install.sh
```

Run it as your normal user. It asks for `sudo` only when the detected package manager needs it. The installer detects a package manager, maps a short list of logical tools to that manager's package names, installs Zsh and tmux plugins, and restores the included configs. Existing files are copied to `~/.local/state/linux-dev-setup/backups/` before replacement.

Package-manager adapters are provided for apt, dnf-compatible commands (dnf5, microdnf, and yum), pacman, zypper, apk, xbps, emerge, Nix, Guix, and Homebrew on Linux. The repository is not tied to a distro: adding a package-manager adapter does not change the dotfile restore flow. If no supported manager is found, configs are still restored and plugin downloads are attempted; install tools manually or add an adapter in `scripts/lib.sh`. Set `LINUX_SETUP_PACKAGE_MANAGER` to choose an adapter when multiple managers are installed.

For Nix, the installer uses `nix profile install` and therefore needs the `nix-command` and `flakes` features enabled. Nix documents this command as experimental, so the package adapter may need updating as Nix changes.

## Options

```bash
./install.sh --dotfiles-only
./install.sh --packages-only
```

The script may ask whether to make Zsh the default login shell. Press Enter to accept. Set `LINUX_SETUP_NO_CHSH=1` to skip that prompt.

## Included setup

- Zsh with Oh My Zsh, Powerlevel10k, autosuggestions, and syntax highlighting
- tmux with TPM and the repo's tmux config
- Optional terminal tools such as Neovim, fzf, ripgrep, fd, eza, bat, and zoxide
- Portable Zsh aliases and startup files

The installer also tries to install the configured tmux plugins through an isolated tmux server. If network access is unavailable, start tmux and press `Ctrl+a`, then `I` later. Powerlevel10k looks best with a Nerd Font configured in your terminal.

The former `packages.txt` was a machine-specific package snapshot; it is kept under `packages/legacy-dpkg-snapshot.txt` for reference and is not used by the installer. The installer only manages its listed dotfiles and does not copy credentials, `.ssh`, Git identity, or application state.
