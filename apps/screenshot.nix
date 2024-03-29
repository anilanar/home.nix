{ pkgs, config, ... }:

let
  screenshot = pkgs.writeScriptBin "screenshot" ''
    #!${pkgs.stdenv.shell}
    ${pkgs.scrot}/bin/scrot -s -f --line style=dash,width=3,color=red ${config.home.homeDirectory}/Pictures/%Y-%m-%d-%H-%M-%S.png
  '';
in { home.packages = [ screenshot ]; }

