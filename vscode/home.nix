{ pkgs, unstable, ... }:
let
  exts = import ./vscode-extensions.nix { inherit pkgs; };
  config = import ./vscode-config.nix { inherit pkgs; };
in {
  home.packages = [ (import ./update-vscode-exts.nix { inherit pkgs; }) ];
  programs.vscode = {
    enable = true;
    package = unstable.vscodium;
    extensions = with exts; [ nix vim nixfmt ];
    userSettings = config.userSettings;
    keybindings = config.keybindings;
  };
}
