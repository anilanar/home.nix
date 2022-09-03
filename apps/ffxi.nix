{ pkgs, unstable, config, ... }:

let
  wine = pkgs.wineWowPackages.staging;
  catseye = pkgs.writeScriptBin "catseye" ''
    #!${pkgs.stdenv.shell}
    cd /d8a/wine/Ashita
    WINEARCH=win64 WINEPREFIX=/d8a/wine/catseye ${wine}/bin/wine injector.exe toriko.xml
  '';
  catseye2 = pkgs.writeScriptBin "catseye2" ''
    #!${pkgs.stdenv.shell}
    cd /d8a/wine/Ashita
    WINEARCH=win64 WINEPREFIX=/d8a/wine/catseye2 ${wine}/bin/wine injector.exe toriko2.xml
  '';
in { home.packages = [ catseye catseye2 wine pkgs.winetricks ]; }
