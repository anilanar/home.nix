{ pkgs, config, lib, ... }: {

  home.packages = with pkgs;
    [
      wofi
      i3status-rust
      # wl-clipboard-x11
      # swaylock
      # swayidle
      # mako
      # waybar
    ];

  xsession.windowManager.i3 = {
    enable = true;
    # wrapperFeatures.gtk = true;
    config = {
      terminal = "${pkgs.kitty}/bin/kitty";
      modifier = "Mod4";

      focus.mouseWarping = false;
      focus.followMouse = false;
      bars = [{
        id = "main";
        position = "top";
        fonts = [ "JetBrains Mono 10" ];
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rust";
      }];

      fonts = [ "JetBrains Mono 10" ];

      # input = {
      #   "*" = {
      #     repeat_delay = "200";
      #     repeat_rate = "40";
      #   };
      # };

      keybindings = let m = config.xsession.windowManager.i3.config.modifier;
      in lib.mkOptionDefault {
        "${m}+d" = null;
        "${m}+Shift+c" = "kill";
        "${m}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
      };
    };
  };

  programs.i3status-rust = {
    enable = true;

    bars = {
      top = {
        blocks = [{
          block = "time";
          interval = 60;
          format = "%a %d/%m %R";
        }];
      };
    };
  };
  # xsession.windowManager.command = "${pkgs.sway}/bin/i3";

  # services.kanshi = {
  #   enable = true;
  #   profiles = {
  #     home = {
  #       outputs = [
  #         {
  #           criteria = "Goldstar Company Ltd LG HDR 4K 0x00006F7B";
  #           mode = "3840x2160@59.997002Hz";
  #           position = "1920,0";
  #           # scale = 1.5;
  #         }
  #         {
  #           criteria = "BenQ Corporation BenQ GL2460 59E02516SL0";
  #           mode = "1920x1080@60Hz";
  #           position = "0,0";
  #         }
  #       ];

  #     };
  #   };
  # };

  # nixpkgs.overlays = [
  #   (self: super: {
  #     wl-clipboard-x11 = super.stdenv.mkDerivation rec {
  #       pname = "wl-clipboard-x11";
  #       version = "5";

  #       src = super.fetchFromGitHub {
  #         owner = "brunelli";
  #         repo = "wl-clipboard-x11";
  #         rev = "v${version}";
  #         sha256 = "1y7jv7rps0sdzmm859wn2l8q4pg2x35smcrm7mbfxn5vrga0bslb";
  #       };

  #       dontBuild = true;
  #       dontConfigure = true;
  #       propagatedBuildInputs = [ super.wl-clipboard ];
  #       makeFlags = [ "PREFIX=$(out)" ];
  #     };

  #     xsel = self.wl-clipboard-x11;
  #     xclip = self.wl-clipboard-x11;
  #   })
  # ];
}

