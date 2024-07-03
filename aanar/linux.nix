{ pkgs, config, ... }:
{
  imports = [
    ./common.nix
    ../shared/linux.nix
  ];

  home.packages =

    let
      op = "/run/wrappers/bin/op";
      tsh_ = pkgs.writeScriptBin "tsh_" ''
        #!${pkgs.expect}/bin/expect

        set args [lrange $argv 0 end]
        set timeout 2

        spawn -noecho ${pkgs.teleport}/bin/tsh {*}$args
        expect {
          -ex "Enter password for Teleport user anilanar:\r" {
            send "$env(TELEPORT_PASSWORD)\r"
            expect -ex "Enter your OTP token:\r"
            send "$env(TELEPORT_OTP)\r"
            interact
          }
          timeout interact
          eof 
        }
      '';
      tsh = pkgs.writeScriptBin "tsh" ''
        #!${pkgs.stdenv.shell}

        TELEPORT_PASSWORD="op://Private/Teleport/password" \
          TELEPORT_OTP="op://Private/Teleport/one-time password?attribute=otp" \
          ${op} run -- ${tsh_}/bin/tsh_ "$@"
      '';
    in
    with pkgs;
    [
      chiaki
      tsh
      libreoffice
    ];

  programs.zsh = {
    shellAliases = {
      op = "/run/wrappers/bin/op";
    };
  };
}
