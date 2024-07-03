{
  pkgs,
  config,
  unstable,
  ...
}:
{
  imports = [ ../shared/common.nix ];

  programs.git = {
    userName = "Anil Anar";
    userEmail = "anilanar@hotmail.com";
    signing = {
      key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDG5azctgXKFldK4+z+ExEH6mE+3dwBkM/Xg3mOZ+AsGChZTfuACD3+6pneMuIylwbGsa8OmocO/MWvQHQhN8iTAnDgbFO+q8QR71NbqKr2VfjS5jyNCwaiZM9svuufEiTyRx4SiBvEK3DzXCJWRyTAaLNcdFsK87/DNf0gDu7bfZgs59ynHAD3kCxFDHJstltRf+ZzC1Vg4aw5uxshocEiwWaCAxXl1aapPSkP9E0gNi9FoNq/ZQAJWahXcjRqTlu/Q2E04ZQFRlDHEcu3woR5the4+JS2sIdCaeUHkXou2DyECvH8GMTpZw7Mh6orvdDAppS4XNpCiLzcQtEKH39vuPue2MOPtGn8UIKRFVbBWuDsjw80aj7dSU4Nhg5ikqB3kFPWQfBSYn1eS94FxRUsZhtKQpo5AgToTxpNawBhlROmdWCMzaKIed2hkSYr/dTfIP06POMk3+XQ/Rn7gnnal4tm/uLr0J8I9B+ztUjbti1RkC0lM8rgxzVezp05J8Ca+hoNgw5vFvv00+oP5FWr+Q63FirQRQ+fu+33NfIEEGsBFovzlvCBOM4K7Sn+F02K5MZ6gm//z7b5TYI58RGnWthNxRazf6lSczt92xo5NnAQhMDsFPMePonrI2YdM/iXBQAljqMUrdiN6fQsmJTHotRweQQSExQzQktyXl+bEQ==";
      signByDefault = true;
    };
  };

  programs.ssh =
    let
      piIdentityFile = "${pkgs.writeText "pi.pub" ''
        ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXbyTmuDBndHXPfqssKZzkVYRgthoGk2JbTbEozwj13
      ''}";
    in
    {
      matchBlocks =
        {
          "pi" = {
            user = "pi";
            identityFile = piIdentityFile;
            identitiesOnly = true;
          };
          "pi2" = {
            user = "pi";
            identityFile = piIdentityFile;
            identitiesOnly = true;
          };
          "*.teleport.userlike.com teleport.userlike.com" = {
            identityFile = "${config.home.homeDirectory}/.tsh/keys/teleport.userlike.com/anilanar";
            certificateFile = "${config.home.homeDirectory}/.tsh/keys/teleport.userlike.com/anilanar-ssh/teleport.userlike.com-cert.pub";
            extraOptions = {
              HostKeyAlgorithms = "rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com";
              UserKnownHostsFile = "${config.home.homeDirectory}/.tsh/known_hosts";
            };
          };
          "*.teleport.userlike.com !teleport.userlike.com" = {
            port = 3022;
            proxyCommand = "${pkgs.teleport}/bin/tsh -k no proxy ssh --cluster=teleport.userlike.com --proxy=teleport.userlike.com:443 %r@%h:%p";
            forwardAgent = true;
            extraOptions = {
              RequestTTY = "force";
              RemoteCommand = "bash -l";
            };
          };
          "application-ci.teleport.userlike.com" = {
            user = "anilanar";
          };
        }
        // (
          let
            playgroundHosts = pkgs.lib.concatStringsSep " " (
              builtins.map (
                x:
                "playground-development${
                  pkgs.lib.fixedWidthString 2 "0" (builtins.toString x)
                }.teleport.userlike.com"
              ) (pkgs.lib.range 1 9)
            );
          in
          {
            "${playgroundHosts}" = {
              user = "anilanar";
            };
          }
        );
    };

  programs.zsh =
    let
      hub = "/etc/profiles/per-user/aanar/bin/hub";
      gh = "/etc/profiles/per-user/aanar/bin/gh";
      github-auth_ = ''GITHUB_TOKEN=$(op item get Github --account my.1password.com --vault "Personal" --fields label=Nixos)'';
      gh-auth_ = ''GH_TOKEN=$(op item get Github --account my.1password.com --vault "Personal" --fields label=Nixos)'';
    in
    {
      shellAliases = {
        github-auth = "export ${github-auth_}";
        gh-auth = "export ${gh-auth_}";
        npm-auth = ''export NPM_AUTH_TOKEN=$(op item get Npmjs --account my.1password.com --vault "Personal" --fields label=Nixos)'';
        hub_ = "${github-auth_} ${hub}";
        gh_ = "${gh-auth_} ${gh}";
        pr = "gh pr list --assignee '@me' --json title,url";
        c = "${gh-auth_} /etc/profiles/per-user/aanar/bin/code";
      };
    };
}
