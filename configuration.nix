{ config, pkgs, ... }: {
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
    interfaces.enp31s0.useDHCP = true;
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
  ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  sound.enable = true;

  security.rtkit.enable = true;

  hardware.nvidia = { modesetting.enable = true; };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    # Failed attempt at enabling gpu accel for video decoding in chromium.
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
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
    displayManager.gdm = { enable = true; };
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
  };

  programs.sway = { enable = true; };

  # services.avahi = {
  #   enable = true;
  #   nssmdns = true;
  # };

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
        "$6$VJh4kzlF3$sstyFietVaxr4swSwX9wyV2xhawy6F5Cm1Tb9NHvzXjQXfRxlqpGxLdXnZrz/V34cUYyTctOEqw0a4P980Iq11";
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

  # services.udev.packages = [ (import ./uhk-agent) ];

  # iOS file sync and modem daemon
  services.usbmuxd.enable = true;

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  services.paperless-ng = {
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
