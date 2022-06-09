{ pkgs, config, ... }:

let
  xset = pkgs.xorg.xset;
  caffeinate = pkgs.writeScriptBin "caffeinate" ''
    #!${pkgs.stdenv.shell}
    ${xset}/bin/xset s 0 0
    ${xset}/bin/xset dpms 0 0 0
    ${xset}/bin/xset -dpms
  '';
  # I don't know the default values yet. Fill them out
  # after a fresh reboot.
  decaffeinate = pkgs.writeScriptBin "decaffeinate" ''
    #!${pkgs.stdenv.shell}
    ${xset}/bin/xset s 0 0
    ${xset}/bin/xset dpms 0 0 0
    ${xset}/bin/xset -dpms
  '';
in { home.packages = [ caffeinate decaffeinate ]; }

