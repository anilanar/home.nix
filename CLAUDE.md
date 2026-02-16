# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Nix flake managing system and user configurations for two machines:
- **aanar-nixos** (x86_64-linux) — NixOS desktop with NVIDIA GPU, GNOME/Wayland, gaming
- **userlike-macbook** (aarch64-darwin) — Apple Silicon MacBook via nix-darwin

Uses **Home Manager** for user-level config and **flake-utils-plus** for host definitions.

## Build & Deploy

```bash
# macOS
./switch-darwin.sh

# NixOS
./switch-nixos.sh
```

Format Nix files with `nixfmt`.

## Architecture

```
flake.nix                     # Entry point: defines hosts, inputs, overlays
├── configuration.nix         # NixOS system config (boot, networking, GPU, services)
├── macos-configuration.nix   # nix-darwin system config (defaults, fonts, keyboard)
├── shared/                   # Platform-conditional user config (Home Manager)
│   ├── common.nix            # Universal: git, zsh, kitty, fzf, starship, direnv
│   ├── vim.nix               # Vim plugins and settings
│   ├── macos.nix             # 1Password SSH agent, Hammerspoon, Claude hooks
│   └── linux.nix             # GNOME apps, dconf, extensions
├── aanar/                    # User "aanar" (primary user on both machines)
│   ├── common.nix            # Identity (git user, SSH keys), imports shared/common.nix
│   ├── macos.nix             # macOS packages, imports shared/macos.nix
│   └── linux.nix             # Linux packages, imports shared/linux.nix
└── 0commitment/              # Secondary Linux user (gaming)
```

**Import chain**: `aanar/macos.nix` → `aanar/common.nix` → `shared/common.nix` → `shared/vim.nix`. Each layer adds platform- or user-specific config on top.

## Key Details

- Nixpkgs channel: 25.11 with unstable overlay available (`pkgs.unstable.*`)
- Unfree packages are allowed globally
- 1Password handles SSH key signing and agent on both platforms
- The `rfv` shell function (defined in `shared/common.nix`) is a ripgrep+fzf file search tool
- Cachix substituters: nix-gaming, nix-community, devenv
- NixOS state version: 19.09; macOS state version: 5
