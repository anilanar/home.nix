{ pkgs, unstable, config, ... }:

let
  wine = pkgs.wineWowPackages.staging;
  ffxi = pkgs.writeScriptBin "ffxi" ''
    #!${pkgs.stdenv.shell}
    cd /d8a/wine/wingsxi-64/drive_c/WingsXI/Ashita
    WINEARCH=win64 WINEPREFIX=/d8a/wine/wingsxi-64 ${wine}/bin/wine injector.exe nectar.xml
  '';
in { home.packages = [ ffxi wine pkgs.winetricks unstable.lutris ]; }

