{ pkgs ? import <nixpkgs> { } }:

let
  bin = pkgs.bundlerApp {
    pname = "airplayer";
    exes = [ "airplayer" ];
    gemdir = ./.;
    gemConfig = pkgs.defaultGemConfig // {
      dnssd = attrs: {
        buildFlags = [ "--with-dnssd-dir=${pkgs.avahi-compat}" ];
      };
    };
    buildInputs = [ pkgs.avahi pkgs.avahi-compat ];
  };
in bin
