{
  config,
  pkgs,
  lib,
  inputs,
  unstable,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  nix.package = pkgs.nixFlakes;

  nix.settings = {
    substituters = [
      "https://nix-gaming.cachix.org"
      "https://nix-community.cachix.org"
    ];
    trusted-public-keys = [
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
    min-free = ${toString (10 * 1024 * 1024 * 1024)}
    max-free = ${toString (50 * 1024 * 1024 * 1024)}
  '';

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  boot.loader = {
    timeout = 1;
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      extraConfig = ''
        set timeout_style=hidden
      '';
      splashImage = null;
    };
  };

  networking = {
    useNetworkd = false;
    hostName = "aanar-nixos";
    firewall = {
      enable = true;
      # 53317 = localsend
      allowedTCPPorts = [
        21
        5000
        53317
      ];
      # 53317 = localsend
      allowedUDPPorts = [ 53317 ];
    };
    enableIPv6 = true;
    networkmanager = {
      enable = true;
      # dns = "systemd-resolved";
      # extraConfig = ''
      #   rc-manager=resolvconf
      # '';
    };
    # resolvconf = {
    #   enable = false;
    #   package = lib.mkForce pkgs.systemd;
    # };
  };

  # services.resolved = {
  #   enable = false;
  #   dnssec = "false";
  #   extraConfig = ''
  #     DNS=45.90.28.0#861d21.dns.nextdns.io
  #     DNS=2a07:a8c0::#861d21.dns.nextdns.io
  #     DNS=45.90.30.0#861d21.dns.nextdns.io
  #     DNS=2a07:a8c1::#861d21.dns.nextdns.io
  #     DNSOverTLS=opportunistic
  #   '';
  # };

  systemd.network.wait-online.enable = false;

  # services.dnscrypt-proxy2 = {
  #   enable = false;
  #   settings = {
  #     server_names = [ "NextDNS-861d21" ];
  #     static."NextDNS-861d21".stamp =
  #       "sdns://AgEAAAAAAAAAAAAOZG5zLm5leHRkbnMuaW8HLzg2MWQyMQ";
  #   };
  # };

  # systemd.services.dnscrypt-proxy2.serviceConfig = {
  #   StateDirectory = "dnscrypt-proxy";
  # };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

  console.keyMap = "us";

  time.timeZone = "Europe/Amsterdam";

  programs.steam.enable = true;

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [
      "aanar"
      "0commitment"
    ];
    package = unstable._1password-gui;
  };

  environment.systemPackages =
    with pkgs;
    [
      wget
      vimHugeX
      firefox
      polkit
      git
      ntfs3g
      # required by steam
      xdg-user-dirs
    ]
    ++ (with gnomeExtensions; [
      espresso
      vitals
      tray-icons-reloaded
      auto-move-windows
    ]);

  programs.seahorse.enable = true;

  sound = {
    enable = true;
    extraConfig = ''
      pcm_type.jack {
        lib "${pkgs.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_jack.so"
      }
    '';
  };

  hardware.nvidia = {
    modesetting.enable = true;
    # enable suspend/resume video memory save/
    powerManagement.enable = true;
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Logitech G29 module
  hardware.new-lg4ff.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # hardware.bluetooth.enable = true;

  # services.blueman.enable = true;

  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # config.pipewire = let
    #   defaultConfig = lib.importJSON
    #     "${inputs.nixpkgs}/nixos/modules/services/desktops/pipewire/daemon/pipewire.conf.json";
    # in lib.recursiveUpdate defaultConfig {
    #   # Create a virtual source to convert left-only behringer mic to a mono source.
    #   "context.modules" = defaultConfig."context.modules" ++ [{
    #     name = "libpipewire-module-loopback";
    #     args = {
    #       "node.description" = "Behringer Mic";
    #       "capture.props" = {
    #         "node.name" = "capture.behringer-left";
    #         "audio.position" = [ "FL" ];
    #         "stream.dont-remix" = true;
    #         "node.passive" = true;
    #         "node.target" =
    #           "alsa_input.usb-BEHRINGER_UMC202HD_192k-00.pro-input-0";
    #       };
    #       "playback.props" = {
    #         "node.name" = "behringer-left";
    #         "media.class" = "Audio/Source";
    #         "audio.position" = [ "MONO" ];
    #       };
    #     };
    #   }];
    # };
  };

  services.xserver = {
    enable = true;
    # xkb = {
    #   layout = "us";
    # };
    # exportConfiguration = true;
    # dpi = 120;
    videoDrivers = [ "nvidia" ];

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome = {
      enable = true;
      extraGSettingsOverridePackages = [
        pkgs.gnome.mutter
        pkgs.gnome.gnome-weather
      ];
    };
    # autoRepeatDelay = 200;
    # autoRepeatInterval = 40;

    # Disable touchpad on PS5 controller
    # config = ''
    #   Section "InputClass"
    #         Identifier   "ds-touchpad"
    #         Driver       "libinput"
    #         MatchProduct "Wireless Controller Touchpad"
    #         Option       "Ignore" "True"
    #   EndSection
    # '';
  };

  services.displayManager.defaultSession = "gnome";

  # services.libinput = {
  #   enable = true;

  #   # For Apple Magic trackpad
  #   touchpad = {
  #     naturalScrolling = true;
  #     accelSpeed = "0.5";
  #   };
  # };

  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
    };
  };

  programs.zsh.enable = true;

  services.chrony.enable = true;

  services.jupyter = {
    enable = false;
    user = "jupyter";
    group = "jupyter";
    notebookDir = "/d8a/jupyter";
    password = "'argon2:$argon2id$v=19$m=10240,t=10,p=8$9fSNkRYrTCN19clLIDY5gQ$Mode1HopQlpw3bw43aX9VPDHQd8eNyX/vTO/13nX3Lc'";
  };

  environment.pathsToLink = [ "/share/zsh" ];
  environment.shells = with pkgs; [
    bashInteractive
    zsh
  ];

  users = {
    mutableUsers = false;
    users.aanar = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
        "audio"
        "networkmanager"
        # "jupyter" 
      ];
      hashedPassword = "$y$j9T$opqRCjEPf69SbcdYjddaD1$zUX94iWhyj.HUA2X1NX96dG3HYr5oIVfrlNAL6n27p.";
      createHome = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        ''
          ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILXZZU1n6ycmCodfRgcQkMUaXFVnmjY9816GKC51Jaa4 homebridge@pi
        ''
      ];
    };
    users."0commitment" = {
      isNormalUser = true;
      extraGroups = [
        "wheel"
        "docker"
        "audio"
        "networkmanager"
      ];
      hashedPassword = "$6$hHx4Fe2HYmruw1My$I67l2lb5OtkVHM8rI0.RNXExoqMcUpLOJ9dERkTknYGURJGSiGlR9D7Wr4i2M4SjUIw9M7uJ6QPlrqS4yo0jd/";
      createHome = true;
      shell = pkgs.zsh;
    };
    users."paperless" = {
      isNormalUser = false;
      isSystemUser = true;
      group = "paperless";
      # extraGroups = [ "wheel" ];
      hashedPassword = "$6$NpR0PnR92qjqhG2N$BUaq0saElrTxaI0pjU7BYSkEVHqfvUz17uopw/WOLL/G6mogrRhSlLgsnCoXMsQP.GRfW0Bxg6p4eUWiu2sC80";
      createHome = false;
    };
    users.root = {
      isSystemUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "$y$j9T$opqRCjEPf69SbcdYjddaD1$zUX94iWhyj.HUA2X1NX96dG3HYr5oIVfrlNAL6n27p.";
    };
    # users.jupyter = { group = "jupyter"; };
    groups = {
      onepassword-cli = {
        gid = 1001;
      };
      paperless = { };
    };
  };

  hardware.keyboard.uhk.enable = true;

  # iOS file sync and modem daemon
  services.usbmuxd.enable = true;

  security.sudo = {
    extraRules = [
      {
        commands = [
          {
            command = "${pkgs.systemd}/bin/systemctl suspend";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/systemctl reboot";
            options = [ "NOPASSWD" ];
          }
          {
            command = "${pkgs.systemd}/bin/systemctl poweroff";
            options = [ "NOPASSWD" ];
          }
        ];
        groups = [ "wheel" ];
      }
    ];
  };

  security.polkit.enable = true;

  security.pam.loginLimits = [
    {
      domain = "*";
      item = "memlock";
      type = "hard";
      value = "unlimited";
    }
    {
      domain = "*";
      item = "memlock";
      type = "soft";
      value = "unlimited";
    }
  ];

  security.protectKernelImage = false;

  security.rtkit.enable = true;

  security.wrappers = {
    # 1password cli with custom group required by 1password
    op = {
      setgid = true;
      owner = "root";
      group = "onepassword-cli";
      source = "${unstable._1password}/bin/op";
    };
  };

  systemd.targets.suspend.enable = true;
  services.logind.extraConfig = ''
    IdleAction=suspend
    IdleActionSec=20s
  '';

  services.paperless = {
    enable = false;
    user = "paperless";
    address = "0.0.0.0";
  };

  services.vsftpd = {
    enable = true;
    userlist = [ "paperless" ];
    writeEnable = true;
    localUsers = true;
    localRoot = "/var/lib/paperless/consume";
  };

  services.udisks2.enable = true;

  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
  };

  # fonts = {
  #   packages = [
  #     pkgs.dejavu_fonts
  #     pkgs.jetbrains-mono
  #   ];
  #   fontconfig = {
  #     enable = true;
  #     defaultFonts.monospace = [ "JetBrains Mono 14" ];
  #   };
  #   fontDir.enable = true;
  #   enableDefaultPackages = true;
  # };

  services.ollama = {
    enable = true;
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09";
}
