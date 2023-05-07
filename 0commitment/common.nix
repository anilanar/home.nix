{ pkgs, unstable, config, ... }: {
  imports = [ ../shared/common.nix ];

  home.packages = with pkgs; [
    unstable.duckstation # ps1
    unstable.pcsx2 # ps2
    unstable.rpcs3 # ps3
    unstable.snes9x-gtk # snes
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
          # "IdentityAgent" = "~/.1password/agent.sock";
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

