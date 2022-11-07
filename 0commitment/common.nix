{ pkgs, config, ... }: {
  imports = [ ../shared/common.nix ];

  home.packages = with pkgs; [
    duckstation # ps1
    pcsx2 # ps2
    rpcs3 # ps3
  ];

  programs.git = {
    userName = "0commitment";
    userEmail = "0.commitment.tv@gmail.com";
    signing = {
      key = "";
      signByDefault = true;
    };
  };

  programs.ssh = {
    matchBlocks = {
      "*" = {
        extraOptions = {
          # keyring ssh agent location
          "IdentityAgent" = "/run/user/1003/keyring/ssh";
        };
      };
    };

  };

  programs.zsh = {
    # envExtra = ''
    #   export GITHUB_TOKEN=$(cat /run/user/1000/secrets/github_token)
    #   export NPM_AUTH_TOKEN=$(cat /run/user/1000/secrets/npm_token)
    # '';
  };
}

