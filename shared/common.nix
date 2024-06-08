{ pkgs, config, lib, unstable, ... }:

{
  imports = [ ./vim.nix ];

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

  home.sessionVariables = {
    VISUAL = "${pkgs.vim}/bin/vim";
    EDITOR = "${pkgs.vim}/bin/vim";
    SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";
  };

  home.packages = with pkgs; [
    bash
    nodejs_20
    gitAndTools.hub
    gitAndTools.git-extras
    gitAndTools.git-recent
    # unstable.graphite-cli
    gh
    autojump
    nixfmt-rfc-style
    # CLI file explorer with vim bindings
    ranger
    ripgrep
    # A font
    jetbrains-mono
    unzip
    killall
    openvpn
    watson

    # dependency of thefuck oh-my-zsh plugin
    thefuck
  ];

  programs.git = {
    enable = true;
    delta = { enable = true; };
    ignores = [ "*~" ".swp" ".envrc" "shell.nix" ".direnv" ];
    extraConfig = {
      http = lib.mkIf (!pkgs.stdenv.isDarwin) {
        sslcainfo = "/etc/ssl/certs/ca-bundle.crt";
      };
      pull = { ff = "only"; };
      init = { defaultBranch = "main"; };
      gpg.format = "ssh";
      # "gpg \"ssh\"".program = "${config.home.homeDirectory}/.1password/op-ssh-sign";

    };
  };

  programs.ssh = {
    enable = true;
    extraConfig = ''
      AddKeysToAgent no
      AddressFamily inet
      IdentityAgent ${config.home.homeDirectory}/.1password/agent.sock
    '';
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    autosuggestion.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins =
        [ "vi-mode" "git" "docker" "kubectl" "node" "thefuck" "vscode" ];
    };

    shellAliases = {
      ggrh = "gfo && git reset --hard origin/$(current_branch)";
      sshx = "${pkgs.kitty}/bin/kitty +kitten ssh";
      tr = "trash";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = { enable = true; };
    config = { global = { hide_env_diff = true; }; };
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
    settings = {
      aws = { disabled = true; };
      gcloud = { disabled = true; };
      nix_shell = { disabled = true; };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.password-store.enable = true;

  fonts.fontconfig.enable = true;

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.htop = {
    enable = true;
    settings = { hide_userland_threads = 1; };
  };
}

