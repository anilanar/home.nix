{ pkgs }:
pkgs.stdenv.mkDerivation {
  name = "update-vscode-exts";

  src = pkgs.fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs";
    rev = "20.03";
    sha256 = "0182ys095dfx02vl2a20j1hz92dx3mfgz2a6fhn31bqlp1wa8hlq";
  };

  installPhase = ''
    mkdir -p $out/bin
    cp pkgs/misc/vscode-extensions/update_installed_exts.sh $out/bin/update-vscode-exts
  '';
}
