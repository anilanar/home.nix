{ pkgs, config, ... }: {
  imports = [ ../shared/common.nix ];
  programs.git = {
    userName = "Anil Anar";
    userEmail = "anilanar@hotmail.com";
    signing = {
      key = "8A9CE13B59366434";
      signByDefault = true;
    };
  };

  programs.ssh = {
    matchBlocks = {
      "*.userlike.com" = {
        user = "anilanar";
        identityFile = "${config.home.homeDirectory}/.ssh/id_rsa.userlike";
        forwardAgent = true;
      };
      "94.130.106.179 94.130.57.204 116.203.23.226 116.203.62.43 94.130.227.25 78.47.104.128 95.217.238.95" =
        {
          user = "anilanar";
          identityFile = "${config.home.homeDirectory}/.ssh/id_rsa.userlike";
          forwardAgent = true;
        };
    };
  };

  programs.zsh = {
    envExtra = ''
      export GITHUB_TOKEN=$(cat /run/user/1000/secrets/github_token)
      export NPM_AUTH_TOKEN=$(cat /run/user/1000/secrets/npm_token)
    '';
  };
}

