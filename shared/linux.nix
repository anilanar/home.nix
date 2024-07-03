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
    ./gnome-exts.nix
  ];

  home.packages =
    with pkgs;
    [
      chromium
      microsoft-edge
      firefox
      vlc
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
    ]
    ++ (
      let
        teams = pkgs.teams-for-linux.overrideAttrs (old: rec {
          desktopItems = [
            ((builtins.elemAt old.desktopItems 0).override (oldDesktop: {
              exec = "${oldDesktop.exec} --chromeUserAgent \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/121.0.0.0 Safari/537.36 Edg/121.0.0.0\"";
            }))
          ];
        });
      in
      [ teams ]
    );

  home.sessionVariables = {
    SSH_AUTH_SOCK = "\${SSH_AUTH_SOCK:-${config.xdg.configHome}/1password/agent.sock}";

    BROWSER = "${pkgs.firefox}/bin/firefox";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    EGL_PLATFORM = "wayland";
    GST_VAAPI_ALL_DRIVERS = "1";
  };

  home.file.".config/1password/op-ssh-sign".source = "${unstable._1password-gui}/share/1password/op-ssh-sign";

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
