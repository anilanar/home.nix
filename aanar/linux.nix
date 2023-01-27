{ pkgs, config, ... }: {
  imports = [ ./common.nix ../shared/linux.nix ../apps/ffxi.nix ];

  home.packages = with pkgs; [ thunderbird unityhub ];

  sops = {
    gnupg = {
      home = "/home/aanar/.gnupg";
      sshKeyPaths = [ ];
    };
    defaultSopsFile = ./secrets/secrets.json;
    secrets = { github_token = { sopsFile = ./secrets/github.json; }; };
  };
}

