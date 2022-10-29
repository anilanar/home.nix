{ config, pkgs, lib, nixpkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  nix.package = pkgs.nixFlakes;

  nix.extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
  '';

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      steam = pkgs.steam.override { nativeOnly = true; };
    };
  };

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
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  programs.seahorse.enable = true;

  sound = {
    enable = true;
    extraConfig = ''
      pcm_type.jack {
        lib "${pkgs.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_jack.so"
      }
    '';
  };

  security.rtkit.enable = true;

  hardware.nvidia = { 
    modesetting.enable = true;
    # enable suspend/resume video memory save/
    powerManagement.enable = true;
    # open = true;
  };

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
        "${nixpkgs}/nixos/modules/services/desktops/pipewire/daemon/pipewire.conf.json";
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
        "$6$Qjl03JRam$at7WQSMRXgJZ4yZ.c.NxxO3MIhAPztH.XmJO28iKTwZA/3FqDbVAZbqJa0TklQd8DZRxHS7TcWU8obPdIDwPb/";
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
        "$6$K1Ey.k34nAqh1SaA$YHopVafotoyTV3.lZXY/zlNCEACxbhUrh26i0nxqSQ2GnMCKOYgtJwfxf0k7Y.5CBt0zzl9KZD.s6wPn2rhaU.";
    };
  };

  services.udev.packages = [ pkgs.uhk-udev-rules ];

  # iOS file sync and modem daemon
  services.usbmuxd.enable = true;

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;

  services.plex = {
    enable = true;
    openFirewall = true;
  };

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

  virtualisation.docker.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09";

}
