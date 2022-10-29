{ pkgs, config, ... }:

{
  imports = [ ../vscode/home.nix ./vim.nix ];

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
    gitAndTools.hub
    gitAndTools.git-extras
    gitAndTools.git-recent
    gnupg
    autojump
    nixfmt
    # CLI file explorer with vim bindings
    ranger
    ripgrep
    # A font
    jetbrains-mono
    unzip
    htop
    killall
    openvpn
    watson
    uhk-agent

    # dependency of thefuck oh-my-zsh plugin
    thefuck
  ];

  programs.gpg = { enable = true; };

  programs.git = {
    enable = true;
    delta = { enable = true; };
    ignores = [ "*~" ".swp" ".envrc" "shell.nix" ".direnv" ];
    extraConfig = {
      http = { sslcainfo = "/etc/ssl/certs/ca-bundle.crt"; };
      pull = { ff = "only"; };
      init = { defaultBranch = "main"; };
    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
      AddressFamily inet
    '';
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    enableAutosuggestions = true;

    oh-my-zsh = {
      enable = true;
      plugins =
        [ "vi-mode" "git" "docker" "kubectl" "node" "thefuck" "vscode" ];
    };

    shellAliases = {
      ggrh = "gfo && git reset --hard origin/$(current_branch)";
      ssh = "${pkgs.kitty}/bin/kitty +kitten ssh";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = { enable = true; };
  };

  programs.autojump = {
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

  programs.password-store.enable = true;

  fonts.fontconfig.enable = true;
}

