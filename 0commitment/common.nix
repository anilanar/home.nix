{ pkgs, config, ... }: {
  imports = [ ../shared/common.nix ];

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

