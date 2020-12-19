{ pkgs, config, ... }:

{
  imports = [ ./vscode.nix ./vim.nix ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "19.09";

  home.packages = with pkgs; [
    bash
    slack
    vlc
    brave
    direnv
    spotify
    gitAndTools.hub
    gitAndTools.git-extras
    gitAndTools.git-recent
    gnupg
    autojump
    nixfmt
    firefox
    # CLI file explorer with vim bindings
    ranger
    ripgrep
    # A font
    jetbrains-mono
    minetime
    discord
    unzip
  ];

  services.lorri = { enable = true; };

  programs.gpg = { enable = true; };

  programs.git = {
    enable = true;
    userName = "Anil Anar";
    userEmail = "anilanar@hotmail.com";
    signing = {
      key = "8A9CE13B59366434";
      signByDefault = true;
    };
    extraConfig = {
      http = { sslcainfo = "/etc/ssl/certs/ca-bundle.crt"; };
      pull = { ff = "only"; };
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
    matchBlocks = {
      "*.userlike.com" = {
        user = "anilanar";
        identityFile = "${config.home.homeDirectory}/.ssh/id_rsa.userlike";
        forwardAgent = true;
      };
    };
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    envExtra = ''
      export GHT="a3bc60e6f4625643a9ffa1e022b7a4e65f63c354";
    '';
    enableAutosuggestions = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "vi-mode" "git" "autojump" ];
    };

    shellAliases = {
      ggrh = "gfo && git reset --hard origin/$(current_branch)";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono 14";
      package = pkgs.jetbrains-mono;
    };
    settings = { copy_on_select = "clipboard"; };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.chromium = {
    enable = true;
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "khgocmkkpikpnmmkgmdnfckapcdkgfaf" # 1password
    ];
  };

  fonts.fontconfig.enable = true;
}

