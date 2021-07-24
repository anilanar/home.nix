{ config, pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];

  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  nixpkgs.config = { allowUnfree = true; };

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

  networking.hostName = "aanar-nixos";
  networking.useDHCP = false;
  networking.interfaces.enp31s0.useDHCP = true;
  networking.networkmanager.enable = true;

  i18n = { defaultLocale = "en_US.UTF-8"; };
  console.keyMap = "us";

  time.timeZone = "Europe/Amsterdam";

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

  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    configFile = pkgs.runCommand "default.pa" { } ''
      sed 's/load-module module-switch-on-port-available/# \0/g' \
        ${pkgs.pulseaudio}/etc/pulse/default.pa > $out
    '';
    extraConfig = ''
      set-card-profile alsa_card.pci-0000_23_00.1 output:hdmi-stereo-extra2
      load-module module-remap-source source_name=behringer_mono master=alsa_input.usb-BEHRINGER_UMC202HD_192k-00.analog-stereo master_channel_map=front-left channel_map=mono
      set-default-source behringer_mono
    '';
    support32Bit = true;
  };

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    # Failed attempt at enabling gpu accel for video decoding in chromium.
    extraPackages = with pkgs; [ vaapiVdpau libvdpau-va-gl ];
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

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
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  programs.dconf.enable = true;

  services.openssh = {
    enable = true;
    forwardX11 = true;
  };

  services.chrony.enable = true;

  environment.pathsToLink = [ "/share/zsh" ];

  users = {
    mutableUsers = false;
    users.aanar = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "audio" "networkmanager" ];
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
    users.root = {
      isNormalUser = false;
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

  virtualisation.docker.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09";

}
