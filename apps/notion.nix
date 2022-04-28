{ pkgs, config, ... }:

let
  #   appimage = builtins.fetchurl {
  #     url =
  #       "https://github.com/notion-enhancer/notion-repackaged/releases/download/v2.0.18-1/Notion-Enhanced-2.0.18-1.AppImage";
  #     sha256 = "";
  #   };
  #   notion = pkgs.writeScriptBin "notion" ''
  #     #!${pkgs.stdenv.shell}
  #     ${pkgs.appimage-run}/bin/appimage-run ${appimage}
  #   '';
  notion = pkgs.appimageTools.wrapType1 {
    name = "notion";
    src = pkgs.fetchurl {
      url =
        "https://github.com/notion-enhancer/notion-repackaged/releases/download/v2.0.18-1/Notion-Enhanced-2.0.18-1.AppImage";
      sha256 = "SqeMnoMzxxaViJ3NPccj3kyMc1xvXWULM6hQIDZySWY=";
    };
  };
in { home.packages = [ notion ]; }

