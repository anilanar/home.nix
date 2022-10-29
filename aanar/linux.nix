{ pkgs, config, ... }:
{
  imports = [
    ./common.nix
    ../shared/linux.nix
    ../apps/ffxi.nix
    ../apps/i3gamma.nix
  ];

  sops = {
    gnupg = {
      home = "/home/aanar/.gnupg";
      sshKeyPaths = [ ];
    };
    defaultSopsFile = ./secrets/secrets.json;
    secrets = {
      github_token = { sopsFile = ./secrets/github.json; };
      npm_token = { };
    };
  };
}

