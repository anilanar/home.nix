{ pkgs, lib, config, ... }:

{
  home.packages = with pkgs; [ font-awesome ];

  xsession.windowManager.i3 = {
    enable = true;

    config = let modifier = "Mod4";
    in {
      inherit modifier;

      keybindings = lib.mkOptionDefault {
        "${modifier}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";
        "${modifier}+Shift+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${modifier}+Shift+c" = "kill";
        "${modifier}+Shift+q" = "exit";
        "${modifier}+Tab" = "focus next";
        "${modifier}+f" = "fullscreen toggle";

        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioPause" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl prev";

        "XF86AudioRaiseVolume" =
          "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +5% && exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 0";
        "XF86AudioLowerVolume" =
          "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -5% && exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 0";
        "XF86AudioMute" =
          "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
      };

      focus = {
        followMouse = false;
        mouseWarping = false;
      };

      terminal = "${pkgs.kitty}/bin/kitty";

      bars = [{
        mode = "dock";
        position = "top";
        workspaceButtons = true;
        workspaceNumbers = true;
        statusCommand =
          "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
        fonts = {
          names = [ "monospace" "FontAwesome5Free" ];
          size = 10.0;
        };
        trayOutput = "primary";
        colors = {
          background = "#282828";
          statusline = "#ffffff";
          separator = "#666666";
          focusedWorkspace = {
            border = "#4c7899";
            background = "#285577";
            text = "#ffffff";
          };
          activeWorkspace = {
            border = "#333333";
            background = "#5f676a";
            text = "#ffffff";
          };
          inactiveWorkspace = {
            border = "#333333";
            background = "#222222";
            text = "#888888";
          };
          urgentWorkspace = {
            border = "#2f343a";
            background = "#900000";
            text = "#ffffff";
          };
          bindingMode = {
            border = "#2f343a";
            background = "#900000";
            text = "#ffffff";
          };
        };

      }];
    };

    extraConfig = ''
      floating_minimum_size 75 x 50
      floating_maximum_size 1920 x 1080
    '';

    # sway options
    # extraOptions = [ "--unsupported-gpu" "--my-next-gpu-wont-be-nvidia" ];
  };

  programs.i3status-rust = {
    enable = true;
    bars = {
      default = {
        settings = {
          icons = "awesome5";
          theme = "gruvbox-dark";
        };
        blocks = [
          {
            block = "memory";
            display_type = "memory";
            format_mem = "{mem_used_percents}";
            format_swap = "";
            clickable = false;
          }
          {
            block = "cpu";
            interval = 1;
          }
          {
            block = "nvidia_gpu";
            show_memory = false;
            show_clocks = false;
            label = "1060GTX";
          }
          { block = "sound"; }
          # {
          #   block = "watson";
          #   show_time = true;
          #   interval = 10;
          # }
          {
            block = "weather";
            format = "{weather} {temp}";
            service = {
              name = "openweathermap";
              api_key = "d585239612e215094310d7e491b6b438";
              city_id = "2864118";
              units = "metric";
            };
          }
          {
            block = "time";
            format = "%a %d/%m %R";
          }
        ];
      };
    };

  };
}
