{ pkgs, ... }:

{
  imports = [ ./common.nix ./xmonad.nix ./screenshot.nix ];

  home.packages = with pkgs; [
    brave
    vlc
    firefox
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

    partition-manager
    gnome.gnome-disk-utility
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
  };

  services.stalonetray = {
    enable = true;
    config = {
      decorations = "none";
      transparent = false;
      dockapp_mode = "none";
      geometry = "5x1-10+0";
      background = "black";
      kludges = "force_icons_size";
      grow_gravity = "NE";
      icon_gravity = "NE";
      icon_size = 30;
      slot_size = 36;
      sticky = true;
      window_type = "dock";
      window_layer = "top";
      skip_taskbar = true;
    };
  };

  services.blueman-applet.enable = true;

  xresources.properties = {
    "Xft.dpi" = 192;
    "Xft.autohint" = 0;
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
  };

  xsession = {
    enable = true;
    pointerCursor = {
      name = "Vanilla-DMZ-AA";
      package = pkgs.vanilla-dmz;
      size = 128;
    };

    initExtra = ''
      ${pkgs.autorandr}/bin/autorandr --change
      ${pkgs.xlibs.xset}/bin/xset r rate 200 40
      ${pkgs.hsetroot}/bin/hsetroot -solid "#000000"

      nvidia-settings -a 'AllowFlipping=0'
      nvidia-settings --load-config-only

      systemctl --user restart stalonetray
    '';
  };

  services.picom = {
    enable = true;
    vSync = true;
  };

  services.pasystray.enable = true;

  services.udiskie.enable = true;

  services.network-manager-applet.enable = true;

  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableSshSupport = true;
    defaultCacheTtl = 3600;
    defaultCacheTtlSsh = 3600;
    maxCacheTtl = 36000;
  };

  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" ];
  };

  services.spotifyd = {
    enable = true;
    package = pkgs.spotifyd.override { withKeyring = true; };
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

  programs.keychain = {
    enable = true;
    enableXsessionIntegration = true;
    enableZshIntegration = true;
  };

  programs.autorandr = {
    enable = true;
    profiles = import ./autorandr/profiles.nix;
    hooks = {
      postswitch = {
        "notify-xmonad" = "${pkgs.xmonad-with-packages}/bin/xmonad --restart";
      };
    };
  };

  gtk = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      package = pkgs.jetbrains-mono;
    };
    iconTheme = {
      package = pkgs.gnome3.gnome_themes_standard;
      name = "Adwaita";
    };
    gtk3 = {
      extraCss = ''
        scrollbar slider {
          min-width: 1em;
        }
      '';
    };
  };
}

