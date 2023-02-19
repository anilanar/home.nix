{ pkgs, ... }:

{
  imports = [ ./common.nix ];

  programs.zsh = {
    profileExtra = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
    '';
  };

  xdg = { enable = true; };

  xdg.configFile = {
    "yabai/yabairc" = {
      executable = true;
      text = ''
        yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
        sudo yabai --load-sa
      '';
    };
  };
}

