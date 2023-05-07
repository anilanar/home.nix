{ config, pkgs, lib, inputs, unstable, ... }: {
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
  '';

  # nixpkgs.config = { allowUnfree = true; };

  boot.kernelParams = [ "acpi_enforce_resources=lax" ];

  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/efi";
    };
    grub = {
      enable = true;
      version = 2;
      devices = [ "nodev" ];
      efiSupport = true;
    };
  };

  networking = {
    hostName = "aanar-nixos";
    useDHCP = false;
    firewall.enable = false;
    interfaces.enp31s0 = {
      useDHCP = true;
      wakeOnLan.enable = true;
    };
    networkmanager.enable = true;
  };

  i18n = { defaultLocale = "en_US.UTF-8"; };

  console.keyMap = "us";

  time.timeZone = "Europe/Amsterdam";

  programs.steam.enable = true;

  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "aanar" "0commitment" ];
    package = unstable._1password-gui;
  };

  environment.systemPackages = with pkgs; [
    wget
    vimHugeX
    firefox
    polkit
    git
    ntfs3g
    papirus-icon-theme
    hicolor-icon-theme
    gnome3.adwaita-icon-theme
    # required by steam
    xdg-user-dirs
  ];

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
    # modesetting.enable = false;
    # enable suspend/resume video memory save/
    powerManagement.enable = true;
    # open = false;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Logitech G29 module
  hardware.new-lg4ff.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
  };

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    config.pipewire = let
      defaultConfig = lib.importJSON
        "${inputs.nixpkgs}/nixos/modules/services/desktops/pipewire/daemon/pipewire.conf.json";
    in lib.recursiveUpdate defaultConfig {
      # Create a virtual source to convert left-only behringer mic to a mono source.
      "context.modules" = defaultConfig."context.modules" ++ [{
        name = "libpipewire-module-loopback";
        args = {
          "node.description" = "Behringer Mic";
          "capture.props" = {
            "node.name" = "capture.behringer-left";
            "audio.position" = [ "FL" ];
            "stream.dont-remix" = true;
            "node.passive" = true;
            "node.target" =
              "alsa_input.usb-BEHRINGER_UMC202HD_192k-00.pro-input-0";
          };
          "playback.props" = {
            "node.name" = "behringer-left";
            "media.class" = "Audio/Source";
            "audio.position" = [ "MONO" ];
          };
        };
      }];
    };
  };

  services.xserver = {
    enable = true;
    layout = "us";
    exportConfiguration = true;
    dpi = 192;
    videoDrivers = [ "nvidia" ];
    # To enable key composition, but it doesn't work for some reason
    # xkbOptions = "compose:ralt";
    displayManager.session = [{
      manage = "desktop";
      name = "xsession";
      start = "";
    }];

    displayManager.sessionCommands = ''
      xset -dpms 
      xset s blank
      xset s 300
      ${pkgs.lightlocker}/bin/light-locker --idle-hint &
    '';

    displayManager.defaultSession = "xsession";
    displayManager.gdm = {
      enable = true;
      wayland = false;
    };

    libinput = {
      enable = true;

      # For Apple Magic trackpad
      touchpad = {
        naturalScrolling = true;
        accelSpeed = "0.5";
      };
    };
    autoRepeatDelay = 200;
    autoRepeatInterval = 40;

    # Disable touchpad on PS5 controller
    config = ''
      Section "InputClass"
            Identifier   "ds-touchpad"
            Driver       "libinput"
            MatchProduct "Wireless Controller Touchpad"
            Option       "Ignore" "True"
      EndSection
    '';
  };

  # programs.sway = { enable = true; };

  # services.avahi = {
  #   enable = true;
  #   nssmdns = true;
  # };

  # Required for gnome themes and other things
  programs.dconf.enable = true;

  services.openssh = {
    enable = true;
    forwardX11 = true;
  };

  services.chrony.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];
  environment.shells = with pkgs; [ bashInteractive zsh ];

  users = {
    mutableUsers = false;
    users.aanar = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "audio" "networkmanager" "plex" ];
      hashedPassword =
        "$y$j9T$opqRCjEPf69SbcdYjddaD1$zUX94iWhyj.HUA2X1NX96dG3HYr5oIVfrlNAL6n27p.";
      createHome = true;
      shell = pkgs.zsh;
    };
    users."0commitment" = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "audio" "networkmanager" ];
      hashedPassword =
        "$6$hHx4Fe2HYmruw1My$I67l2lb5OtkVHM8rI0.RNXExoqMcUpLOJ9dERkTknYGURJGSiGlR9D7Wr4i2M4SjUIw9M7uJ6QPlrqS4yo0jd/";
      createHome = true;
      shell = pkgs.zsh;
    };
    users."paperless" = {
      isNormalUser = false;
      isSystemUser = true;
      group = "paperless";
      # extraGroups = [ "wheel" ];
      hashedPassword =
        "$6$NpR0PnR92qjqhG2N$BUaq0saElrTxaI0pjU7BYSkEVHqfvUz17uopw/WOLL/G6mogrRhSlLgsnCoXMsQP.GRfW0Bxg6p4eUWiu2sC80";
      createHome = false;
    };
    users.root = {
      isSystemUser = true;
      extraGroups = [ "wheel" ];
      hashedPassword =
        "$y$j9T$opqRCjEPf69SbcdYjddaD1$zUX94iWhyj.HUA2X1NX96dG3HYr5oIVfrlNAL6n27p.";
    };
    groups = { onepassword-cli = { gid = 1001; }; };
  };

  hardware.keyboard.uhk.enable = true;

  # iOS file sync and modem daemon
  services.usbmuxd.enable = true;

  services.gnome.gnome-keyring.enable = true;

  security.polkit.enable = true;

  security.pam.services.login.enableGnomeKeyring = true;

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
      source = "${(import ./apps/1password.nix) pkgs}/bin/op";
    };
  };

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  # Workaround for Plex not quitting gracefully
  systemd.services.plex.serviceConfig = {
    KillSignal = lib.mkForce "SIGKILL";
    Restart = lib.mkForce "no";
    TimeoutStopSec = 10;
    ExecStop = pkgs.writeScript "plex-stop" ''
      #!${pkgs.bash}/bin/bash
      ${pkgs.procps}/bin/pkill --signal 15 --pidfile "${config.services.plex.dataDir}/Plex Media Server/plexmediaserver.pid"
      ${pkgs.coreutils}/bin/sleep 5
    '';
    PIDFile = lib.mkForce "";
  };

  # polkit auth agent
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart =
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  systemd.targets.suspend.enable = true;
  services.logind.extraConfig = ''
    IdleAction=suspend
    IdleActionSec=20s
  '';

  services.paperless = {
    enable = true;
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

  virtualisation.docker.enable = true;

  fonts = {
    fonts = [ pkgs.dejavu_fonts pkgs.jetbrains-mono ];
    fontDir.enable = true;
    enableDefaultFonts = true;
  };

  powerManagement = {
    enable = true;
    # messes up usb devices
    powertop.enable = false;
    scsiLinkPolicy = "med_power_with_dipm";
    cpuFreqGovernor = "ondemand";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09";
}
