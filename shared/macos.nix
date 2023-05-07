{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  programs.zsh = {
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  xdg = { enable = true; };
}
