{ pkgs, config, ... }:

let
  i3gamma = pkgs.rustPlatform.buildRustPackage {
    pname = "i3gamma";
    version = "1.0.0";

    src = pkgs.fetchFromGitHub {
      owner = "whitequark";
      repo = "i3gamma";
      rev = "master";
      sha256 = "g1z/rWE9qr9SwZ6eft4KcDOQMn97PkydAQIZ5sSfQgg=";
    };

    cargoSha256 = "H5Vy7PQr3xsbCG+TqCEThDl4rnvm4+dW1WdTgaOmrew=";
  };
  config = pkgs.writeText "i3gamma-config" ''
    default-gamma = { DP-2 = 1.00, HDMI-0 = 1.00 }

    [[window]]
    title = "Toriko"
    gamma = { DP-2 = 1.50, HDMI-0 = 1.50 }

    [[window]]
    title = "Yoditsu"
    gamma = { DP-2 = 1.50, HDMI-0 = 1.50 }

    [[window]]
    title = "Default - Wine desktop"
    gamma = { DP-2 = 1.50, HDMI-0 = 1.50 }
  '';
  script = pkgs.writeScriptBin "start-i3gamma" ''
    #!${pkgs.stdenv.shell}
    ${i3gamma}/bin/i3gamma ${config}
  '';
in {
  xsession.windowManager.i3.config.startup =
    [{ command = "${script}/bin/start-i3gamma"; }];
}
