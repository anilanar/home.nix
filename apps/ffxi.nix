{ pkgs, unstable, config, ... }:

let
  wine = pkgs.wineWowPackages.staging;
  wings = pkgs.writeScriptBin "wings" ''
    #!${pkgs.stdenv.shell}
    cd /d8a/wine/wingsxi-64/drive_c/WingsXI/Ashita
    WINEARCH=win64 WINEPREFIX=/d8a/wine/wingsxi-64 ${wine}/bin/wine injector.exe nectar.xml
  '';
  tabula = pkgs.writeScriptBin "tabula" ''
    #!${pkgs.stdenv.shell}
    cd /d8a/wine/tabula-rasa/drive_c/TabulaRasa/PlayOnline/Ashita
    WINEARCH=win64 WINEPREFIX=/d8a/wine/tabula-rasa ${wine}/bin/wine injector.exe pluton.xml
  '';
in { home.packages = [ wings tabula wine pkgs.winetricks ]; }
