{ pkgs, unstable, ... }:

{
  imports = [ ./common.nix ../shared/macos.nix ];

  home.packages = with pkgs; [
    cocoapods
    dotnetCorePackages.sdk_9_0_3xx
  ];
}

