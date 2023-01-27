{ pkgs, unstable, config, sops, ... }:

{
  imports = [
    sops
    ./common.nix
    ./i3.nix
    ../apps/screenshot.nix
    ../apps/notion.nix
    ../apps/caffeine.nix
  ];

  home.packages = with pkgs; [
    brave
    chromium
    vlc
    firefox
    cinnamon.nemo
    slack
    discord
    filezilla
    # X11 clipboard manager
    xclip
    xsel
    # Fuzzy app launcher
    dmenu
    # CLI to manage Trash bin
    trash-cli
    # iPhone as USB Modem
    libimobiledevice
    # airplayer cli
    # import ./apps/airplayer
    # pdf reader
    okular
    # roam alternative
    obsidian

    gnome.gnome-disk-utility

    # mpris media player controller
    playerctl

    unstable._1password-gui

    networkmanagerapplet

    obs-studio

    antimicrox

    unstable.uhk-agent
    unstable.lutris

    rar

    xarchiver

    gamescope
  ];

  xsession.windowManager.i3.config = {
    defaultWorkspace = "workspace number 1";
    workspaceOutputAssign = [{
      output = (import ../autorandr).outputs.HDMI;
      workspace = "10";
    }];
    assigns = {
      "8" = [{ class = "^Discord"; }];
      "9" = [{ class = "^Slack"; }];
      "10" = [{ class = "^Steam"; }];
    };

    startup = [
      { command = "${pkgs.slack}/bin/slack"; }
      {
        command = "${pkgs.slack}/bin/antimicrox";
      }
      # { command = "${pkgs.steam}/bin/steam"; }
      {
        command = "${unstable._1password-gui}/bin/1password --silent";
        notification = false;
      }
    ];
  };

  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    # Path to gnome-keyring's ssh-agent socket file
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  };

  services.blueman-applet.enable = true;

  services.playerctld.enable = true;

  xresources.properties = {
    "Xft.dpi" = 192;
    "Xft.autohint" = 0;
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
  };

  home.pointerCursor = {
    name = "Vanilla-DMZ-AA";
    package = pkgs.vanilla-dmz;
    size = 128;
    x11.enable = true;
  };

  xsession = {
    enable = true;

    initExtra = ''
      # ${pkgs.autorandr}/bin/autorandr --change
      ${pkgs.hsetroot}/bin/hsetroot -solid "#000000"

      nvidia-settings -a 'AllowFlipping=0'
      nvidia-settings --load-config-only

      # systemctl --user restart stalonetray
    '';
  };

  services.picom = {
    enable = true;
    vSync = true;
    settings = { xrender-sync-fence = true; };
    backend = "glx";
  };

  services.pasystray.enable = true;

  services.udiskie.enable = true;

  services.network-manager-applet.enable = true;

  services.gnome-keyring = {
    enable = true;
    components = [ "pkcs11" "secrets" "ssh" ];
  };

  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override {
      withKeyring = true;
      withMpris = true;
    };
    settings = {
      global = {
        username = "1218008515";
        backend = "pulseaudio";
        use_keyring = true;
        device_name = "nixos";
        bitrate = 320;
        no_audio_cache = true;
        use_mpris = true;
        device_type = "computer";
      };
    };
  };

  programs.autorandr = {
    enable = true;
    profiles = (import ../autorandr).profiles;
  };

  gtk = {
    enable = true;
    theme = { name = "Adwaita"; };
    # font = {
    #   name = "JetBrains Mono";
    #   package = pkgs.jetbrains-mono;
    # };
    # iconTheme = {
    #   package = pkgs.gnome3.gnome_themes_standard;
    #   name = "Adwaita";
    # };
    gtk3 = {
      extraCss = ''
        scrollbar slider {
          min-width: 1em;
        }
      '';
    };
  };

  xdg = { enable = true; };

  xdg.mimeApps = let
    browser = "firefox.desktop";
    fileManager = "nemo.desktop";
    mail = "thunderbird.desktop";
    calendar = "thunderbird.desktop";
    defaultApplications = {
      "x-scheme-handler/http" = browser;
      "x-scheme-handler/https" = browser;
      "x-scheme-handler/chrome" = browser;
      "text/html" = browser;
      "application/x-extension-htm" = browser;
      "application/x-extension-html" = browser;
      "application/x-extension-shtml" = browser;
      "application/xhtml+xml" = browser;
      "application/x-extension-xhtml" = browser;
      "application/x-extension-xht" = browser;
      "inode/directory" = fileManager;
      "x-scheme-handler/mailto" = mail;
      "x-scheme-handler/webcal" = calendar;
      "text/calendar" = calendar;
    };
    extraAssociations = { };
  in {
    enable = true;
    inherit defaultApplications;
    associations.added = defaultApplications // extraAssociations;
  };
}

