{
  pkgs,
  config,
  lib,
  unstable,
  home-manager-worktrunk,
  ...
}:
let
  kitty-themes = pkgs.fetchFromGitHub {
    owner = "dexpota";
    repo = "kitty-themes";
    rev = "b1abdd54ba655ef34f75a568d78625981bf1722c";
    sha256 = "sha256-RcDmZ1fbNX18+X3xCqqdRbD+XYPsgNte1IXUNt6CxIA=";
  };
  rfv = (
    pkgs.writeShellScriptBin "rfv" ''
      # Switch between Ripgrep mode and fzf filtering mode (CTRL-T)
      rm -f /tmp/rg-fzf-{r,f}
      RG_PREFIX="${pkgs.ripgrep}/bin/rg --column --line-number --no-heading --color=always --smart-case "
      INITIAL_QUERY="''${*:-}"
      ${pkgs.fzf}/bin/fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload:$RG_PREFIX {q}" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind 'ctrl-t:transform:[[ ! $FZF_PROMPT =~ ripgrep ]] &&
          echo "rebind(change)+change-prompt(1. ripgrep> )+disable-search+transform-query:echo \{q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r" ||
          echo "unbind(change)+change-prompt(2. fzf> )+enable-search+transform-query:echo \{q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f"' \
        --color "hl:-1:underline,hl+:-1:underline:reverse" \
        --prompt '1. ripgrep> ' \
        --delimiter : \
        --header 'CTRL-T: Switch between ripgrep/fzf' \
        --preview '${pkgs.bat}/bin/bat --color=always {1} --highlight-line {2}' \
        --preview-window 'up,60%,border-bottom,+{2}+3/3,~3' \
        --bind 'enter:become(echo $(${pkgs.coreutils}/bin/realpath {1}):{2})'
    ''
  );
in
{
  imports = [
    ./neovim.nix
    "${home-manager-worktrunk}/modules/programs/worktrunk.nix"
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.worktrunk = {
    enable = true;
    package = unstable.worktrunk;
    enableZshIntegration = true;
    settings = {
      worktree-path = "{{ repo_path }}/.claude/worktrees/{{ branch | sanitize }}";
      commit.generation = {
        command = "CLAUDECODE= MAX_THINKING_TOKENS=0 claude -p --no-session-persistence --model=sonnet --tools='' --disable-slash-commands --setting-sources='' --system-prompt=''";
      };
      pre-start = "direnv allow";
      step.copy-ignored = {
        exclude = [
          ".devenv/"
          ".direnv/"
          ".pxdiff/"
          ".pxdiff-server/"
          "cdk.out/"
        ];
      };
    };
  };

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
    LESSHISTFILE = "${config.xdg.cacheHome}/less/history";
  };

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.packages = with pkgs; [
    bash
    nodejs_22
    hub
    git-extras
    git-recent
    # unstable.graphite-cli
    gh
    autojump
    nixfmt-rfc-style
    # CLI file explorer with vim bindings
    ranger
    ripgrep
    rfv
    # A font
    jetbrains-mono
    unzip
    killall
    openvpn
    watson

    unstable.devenv

  ];

  programs.git = {
    enable = true;
    ignores = [
      "*~"
      ".swp"
      "flake.nix"
      "flake.lock"
      ".envrc"
      "shell.nix"
      ".direnv"
      ".devenv*"
      "devenv.nix"
      "devenv.lock"
      "devenv.yaml"
      ".pre-commit-config.yaml"
      ".cursor"
      ".lsmcp"
      ".serena"
    ];
    settings = {
      http = lib.mkIf (!pkgs.stdenv.isDarwin) { sslcainfo = "/etc/ssl/certs/ca-bundle.crt"; };
      pull = {
        ff = "only";
      };
      init = {
        defaultBranch = "main";
      };
      gpg.format = "ssh";
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      extraOptions = {
        AddKeysToAgent = "no";
        AddressFamily = "inet";
        IdentityAgent = "${config.xdg.configHome}/1password/agent.sock";
      };
    };
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    autosuggestion.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    oh-my-zsh = {
      enable = true;
      plugins = [
        "vi-mode"
        "git"
        "docker"
        "kubectl"
        "node"
        # "vscode"
      ];
    };

    shellAliases = {
      ggrh = "gfo && git reset --hard origin/$(current_branch)";
      sshx = "${pkgs.kitty}/bin/kitty +kitten ssh";
      tr = "trash";
    };

    initContent = ''
      rfv-widget() {
        local result
        result=$(${rfv}/bin/rfv)
        if [[ -n "$result" ]]; then
          LBUFFER+="$result"
        fi
        zle reset-prompt
      }
      zle -N rfv-widget
      bindkey '^F' rfv-widget

      # --- neovim + claude code bridge ---
      e() {
        local sock="''${NVIM_SOCK:-/tmp/nvim-default.sock}"
        if [ -S "$sock" ]; then
          nvr --servername "$sock" --remote "$@"
        else
          echo "No neovim at $sock — opening new instance"
          nvim "$@"
        fi
      }

      ediff() {
        local sock="''${NVIM_SOCK:-/tmp/nvim-default.sock}"
        if [ -S "$sock" ]; then
          nvr --servername "$sock" -c "DiffviewOpen"
        else
          echo "No neovim at $sock"
        fi
      }

      ediff-close() {
        local sock="''${NVIM_SOCK:-/tmp/nvim-default.sock}"
        nvr --servername "$sock" -c "DiffviewClose" 2>/dev/null
      }

      nv() {
        local name="''${1:-$(basename "$(pwd)")}"
        export NVIM_SOCK="/tmp/nvim-''${name}.sock"
        nvim --listen "$NVIM_SOCK" .
      }
    '';
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    package = unstable.direnv;
    nix-direnv = {
      enable = true;
    };
    stdlib = ''
      PATH_add /Applications/cmux.app/Contents/Resources/bin
    '';
    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };

  programs.autojump = {
    enable = true;
    enableZshIntegration = true;
  };

  xdg.configFile."kitty/theme.conf".source =
    "${kitty-themes}/themes/Monokai.conf";

  xdg.configFile."kitty/open-actions.conf".text = ''
    # Open text files in neovim via nvr
    protocol file
    mime text/*
    action launch --type=background nvr --servername ''${NVIM_SOCK:-/tmp/nvim-default.sock} --remote ''${FILE_PATH}
  '';


  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 14;
      package = pkgs.jetbrains-mono;
    };
    settings = {
      copy_on_select = "clipboard";
      macos_option_as_alt = "yes";
    };
    package = unstable.kitty;
    shellIntegration.enableZshIntegration = true;
    enableGitIntegration = true;
    keybindings = {
      "kitty_mod+t" = "launch --cwd=current --type=tab";
      "cmd+t" = "launch --cwd=current --type=tab";
      "kitty_mod+p" = "kitten hints --type=linenum --linenum-action=background nvr --servername /tmp/nvim-default.sock --remote +{line} {path}";
    };
    extraConfig = ''
      include theme.conf
      macos_titlebar_color background
      active_tab_background #E6DB74
      active_tab_foreground #272822
    '';
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      aws = {
        disabled = true;
      };
      gcloud = {
        disabled = true;
      };
      nix_shell = {
        disabled = true;
      };
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.password-store.enable = true;

  # fonts.fontconfig.enable = true;

  programs.zellij = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.htop = {
    enable = true;
    settings = {
      hide_userland_threads = 1;
    };
  };
}
