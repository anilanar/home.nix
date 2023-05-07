{ pkgs, config, nix-gaming, ... }:

let
  wine = pkgs.wineWowPackages.staging;
  catseye = pkgs.writeScriptBin "catseye" ''
    #!${pkgs.stdenv.shell}
    cd /d8a/wine/Ashita
    direnv exec /d8a/wine/catseye ${pkgs.gamemode}/bin/gamemoderun ${wine}/bin/wine injector.exe toriko.xml
  '';
  catseye2 = pkgs.writeScriptBin "catseye2" ''
    #!${pkgs.stdenv.shell}
    cd /d8a/wine/Ashita
    direnv exec /d8a/wine/catseye ${pkgs.gamemode}/bin/gamemoderun ${wine}/bin/wine injector.exe toriko2.xml
  '';
  horizon = pkgs.writeScriptBin "horizon" ''
    #!${pkgs.stdenv.shell}
    cd /d8a/wine/Ashita
    direnv exec /d8a/wine/horizon ${wine}/bin/wineserver -k
    direnv exec /d8a/wine/horizon ${pkgs.gamemode}/bin/gamemoderun ${wine}/bin/wine injector.exe horizon.xml
  '';
in {
  home.packages = [
    # catseye 
    # catseye2 
    horizon 
    pkgs.wineWowPackages.staging
    pkgs.winetricks
  ];
}
