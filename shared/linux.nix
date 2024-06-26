{ pkgs, unstable, wired, vscode-server, ... }:

{
  imports = [
    vscode-server
    wired
    ./common.nix
    ./i3.nix
    ../apps/screenshot.nix
    ../apps/xidlehook.nix
  ];

  home.packages = with pkgs; [
    chromium
    microsoft-edge
    firefox
    unstable.vscode-fhs
    vlc
    xfce.thunar
    slack
    discord
    filezilla
    # X11 clipboard manager
    xclip
    xsel
    # Fuzzy app launcher
    dmenu
    # CLI to manage Trash bin
    trashy
    # iPhone as USB Modem
    libimobiledevice
    # pdf reader
    okular
    # roam alternative
    obsidian

    gnome.gnome-disk-utility

    # mpris media player controller
    playerctl

    networkmanagerapplet
    unstable.uhk-agent
    unstable.lutris
    rar
    xarchiver
    calibre
    lsof
    unstable.localsend
  ];

  xsession.windowManager.i3.config = {
    defaultWorkspace = "workspace number 1";
    workspaceOutputAssign = [{
      output = (import ../autorandr).outputs.HDMI;
      workspace = "10";
    }];
    assigns = {
      "8" = [ { class = "^Discord"; } { class = "^teams-for-linux$"; } ];
      "9" = [{ class = "^Slack"; }];
      "10" = [{ class = "^Steam"; }];
    };

    startup = [
      { command = "${pkgs.slack}/bin/slack"; }
      {
        command = "${unstable.localsend}/bin/localsend_app";
      }
      # { command = "${pkgs.steam}/bin/steam"; }
      {
        command = "${unstable._1password-gui}/bin/1password --silent";
        notification = false;
      }
    ];
  };

  home.sessionVariables = {
    BROWSER = "${pkgs.firefox}/bin/firefox";

    # HiDPI: https://wiki.archlinux.org/title/HiDPI
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1";
  };

  home.file.".1password/op-ssh-sign".source =
    "${unstable._1password-gui}/share/1password/op-ssh-sign";

  services.blueman-applet.enable = true;

  services.playerctld.enable = true;

  services.wired = {
    enable = true;
    config = ./wired.ron;
  };

  services.vscode-server = {
    enable = true;
    enableFHS = true;
    nodejsPackage = pkgs.nodejs_18;
  };

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
      ${pkgs.autorandr}/bin/autorandr 1_home_single
      ${pkgs.hsetroot}/bin/hsetroot -solid "#000000"

      nvidia-settings -a 'AllowFlipping=0'
      nvidia-settings --load-config-only
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
    enable = false;
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
    theme = {
      name = "Adwaita:dark";
      package = pkgs.gnome.gnome-themes-extra;
    };
    font = {
      name = "DejaVu Sans";
      package = pkgs.dejavu_fonts;
      # size = 16;
    };
    iconTheme = {
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
    cursorTheme = {
      name = "Vanilla-DMZ";
      package = pkgs.vanilla-dmz;
      # size = 16;
    };
    gtk3 = {
      extraCss = ''
        scrollbar slider {
          min-width: 1em;
        }
      '';
    };
  };

  qt = {
    enable = true;
    style = {
      name = "adwaita-dark";
    };
  };

  xdg = { enable = true; };

  xdg.mimeApps = let
    browser = "firefox.desktop";
    fileManager = "thunar.desktop";
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
  xdg.configFile."mimeapps.list".force = true;
}

