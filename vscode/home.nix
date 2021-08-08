{ pkgs, ... }:
let
  exts = import ./vscode-extensions.nix { inherit pkgs; };
  config = import ./vscode-config.nix { inherit pkgs; };
in {
  home.packages = [ (import ./update-vscode-exts.nix { inherit pkgs; }) ];
  programs.vscode = {
    enable = true;
    extensions = with exts; [ nix vim nixfmt copilot ];
    userSettings = config.userSettings;
    keybindings = config.keybindings;
  };
}
