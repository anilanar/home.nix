{ pkgs, ... }:

{
  imports = [ ./common.nix ../shared/macos.nix ];

  home.packages = with pkgs; [
    cocoapods
  ];
}

