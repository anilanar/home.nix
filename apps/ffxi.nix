{ pkgs, unstable, config, ... }:

let
  wine = unstable.wineWowPackages.staging;
  catseye = pkgs.writeScriptBin "catseye" ''
    #!${pkgs.stdenv.shell}
    cd /d8a/wine/Ashita
    WINEARCH=win64 WINEPREFIX=/d8a/wine/catseye ${wine}/bin/wine injector.exe toriko.xml
  '';
  catseye2 = pkgs.writeScriptBin "catseye2" ''
    #!${pkgs.stdenv.shell}
    cd /d8a/wine/Ashita
    WINEARCH=win64 WINEPREFIX=/d8a/wine/catseye ${wine}/bin/wine injector.exe toriko2.xml
  '';
  horizon = pkgs.writeScriptBin "horizon" ''
    #!${pkgs.stdenv.shell}
    cd /d8a/wine/horizon/drive_c/horizon/HorizonXI/Game
    WINEARCH=win64 WINEPREFIX=/d8a/wine/horizon ${wine}/bin/wine Ashita-cli.exe ashita.ini
  '';
in { home.packages = [ catseye catseye2 horizon wine unstable.winetricks ]; }
