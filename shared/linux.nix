{
  pkgs,
  unstable,
  vscode-server,
  ...
}:

{
  imports = [
    vscode-server
    ./common.nix
    ./dconf.nix
  ];

  home.packages = with pkgs; [
    chromium
    microsoft-edge
    firefox
    unstable.vscode
    vlc
    # xfce.thunar
    slack
    discord
    filezilla

    unstable.uhk-agent
    unstable.lutris
    rar
    xarchiver
    calibre
    lsof
    gnome.dconf-editor
    gnome.gnome-tweaks
    unstable.localsend
  ];

  home.sessionVariables = {
    BROWSER = "${pkgs.firefox}/bin/firefox";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    EGL_PLATFORM = "wayland";

    GST_VAAPI_ALL_DRIVERS = "1";
  };

  home.file.".1password/op-ssh-sign".source = "${unstable._1password-gui}/share/1password/op-ssh-sign";

  services.vscode-server = {
    enable = true;
    enableFHS = true;
    nodejsPackage = pkgs.nodejs_18;
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
}
