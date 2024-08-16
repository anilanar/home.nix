{ pkgs, config, ... }:
{
  imports = [
    ./common.nix
    ../shared/linux.nix
  ];

  home.packages = with pkgs; [
    chiaki
    libreoffice
  ];

  programs.zsh = {
    shellAliases = {
      op = "/run/wrappers/bin/op";
    };
  };
}
