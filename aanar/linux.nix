{ pkgs, config, ... }: {
  imports = [ ./common.nix ../shared/linux.nix ../apps/ffxi.nix ];

  home.packages = with pkgs; [ thunderbird ];
}

