{ pkgs, config, unstable, ... }: {
  imports = [ ../shared/common.nix ];

  home.packages =

    let
      teams = pkgs.writeShellScriptBin "teams" ''
        #!${pkgs.stdenv.shell}
        ${pkgs.teams-for-linux}/bin/teams-for-linux --chromeUserAgent "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0"
      '';
    in [
      teams
    ];

  programs.git = {
    userName = "Anil Anar";
    userEmail = "anilanar@hotmail.com";
    signing = {
      key =
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDG5azctgXKFldK4+z+ExEH6mE+3dwBkM/Xg3mOZ+AsGChZTfuACD3+6pneMuIylwbGsa8OmocO/MWvQHQhN8iTAnDgbFO+q8QR71NbqKr2VfjS5jyNCwaiZM9svuufEiTyRx4SiBvEK3DzXCJWRyTAaLNcdFsK87/DNf0gDu7bfZgs59ynHAD3kCxFDHJstltRf+ZzC1Vg4aw5uxshocEiwWaCAxXl1aapPSkP9E0gNi9FoNq/ZQAJWahXcjRqTlu/Q2E04ZQFRlDHEcu3woR5the4+JS2sIdCaeUHkXou2DyECvH8GMTpZw7Mh6orvdDAppS4XNpCiLzcQtEKH39vuPue2MOPtGn8UIKRFVbBWuDsjw80aj7dSU4Nhg5ikqB3kFPWQfBSYn1eS94FxRUsZhtKQpo5AgToTxpNawBhlROmdWCMzaKIed2hkSYr/dTfIP06POMk3+XQ/Rn7gnnal4tm/uLr0J8I9B+ztUjbti1RkC0lM8rgxzVezp05J8Ca+hoNgw5vFvv00+oP5FWr+Q63FirQRQ+fu+33NfIEEGsBFovzlvCBOM4K7Sn+F02K5MZ6gm//z7b5TYI58RGnWthNxRazf6lSczt92xo5NnAQhMDsFPMePonrI2YdM/iXBQAljqMUrdiN6fQsmJTHotRweQQSExQzQktyXl+bEQ==";
      signByDefault = true;
    };
  };

  programs.ssh = let
    piIdentityFile = "${pkgs.writeText "pi.pub" ''
      ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMXbyTmuDBndHXPfqssKZzkVYRgthoGk2JbTbEozwj13
    ''}";
  in {
    matchBlocks = {
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
    };
  };

  programs.zsh = let
    op = "/run/wrappers/bin/op";
    hub = "/etc/profiles/per-user/aanar/bin/hub";
    gh = "/etc/profiles/per-user/aanar/bin/gh";
    github-auth_ = ''
      GITHUB_TOKEN=$(${op} item get Github --account my.1password.com --vault "Personal" --fields label=Nixos)'';
    gh-auth_ = ''
      GH_TOKEN=$(${op} item get Github --account my.1password.com --vault "Personal" --fields label=Nixos)'';
  in {
    shellAliases = {
      github-auth = "export ${github-auth_}";
      gh-auth = "export ${gh-auth_}";
      npm-auth = ''
        export NPM_AUTH_TOKEN=$(${op} item get Npmjs --account my.1password.com --vault "Personal" --fields label=Nixos)'';
      hub_ = "${github-auth_} ${hub}";
      gh_ = "${gh-auth_} ${gh}";
      pr = "gh pr list --assignee '@me' --json title,url";
      c = "${gh-auth_} /etc/profiles/per-user/aanar/bin/code";
    };
  };
}

