{ pkgs, unstable, ... }:

{
  imports = [
    ./common.nix
    ./i3.nix
    ./apps/screenshot.nix
    ./apps/notion.nix
    ./apps/ffxi.nix
  ];

  home.packages = with pkgs; [
    brave
    chromium
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

    gnome.gnome-disk-utility

    # mpris media player controller
    playerctl

    _1password-gui
  ];

  xsession.windowManager.i3.config.assigns = { "9" = [{ class = "^Slack"; }]; };

  xsession.windowManager.i3.config.startup = [
    { command = "${pkgs.slack}/bin/slack"; }
    {
      command = "${pkgs._1password-gui}/bin/1password --silent";
      notification = false;
    }
  ];

  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
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

  xsession = {
    enable = true;
    pointerCursor = {
      name = "Vanilla-DMZ-AA";
      package = pkgs.vanilla-dmz;
      size = 128;
    };

    initExtra = ''
      ${pkgs.autorandr}/bin/autorandr --change
      ${pkgs.hsetroot}/bin/hsetroot -solid "#000000"

      nvidia-settings -a 'AllowFlipping=0'
      nvidia-settings --load-config-only

      # systemctl --user restart stalonetray
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

  programs.keychain = {
    enable = true;
    enableXsessionIntegration = true;
    enableZshIntegration = true;
    agents = [ "gpg" "ssh" ];
    keys = [ "id_rsa" ];
  };

  programs.autorandr = {
    enable = true;
    profiles = import ./autorandr/profiles.nix;
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

