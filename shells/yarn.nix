# yarn built with nix 16
{ pkgs, nodeVersion }:
pkgs.stdenv.mkDerivation rec {
  pname = "yarn";
  version = "1.22.19";

  src = pkgs.fetchzip {
    url =
      "https://github.com/yarnpkg/yarn/releases/download/v${version}/yarn-v${version}.tar.gz";
    sha256 = "sha256-12wUuWH+kkqxAgVYkyhIYVtexjv8DFP9kLpFLWg+h0o=";
  };

  buildInputs = [ pkgs.nodejs-${nodeVersion}_x ];

  installPhase = ''
    mkdir -p $out/{bin,libexec/yarn/}
    cp -R . $out/libexec/yarn
    ln -s $out/libexec/yarn/bin/yarn.js $out/bin/yarn
    ln -s $out/libexec/yarn/bin/yarn.js $out/bin/yarnpkg
  '';
}