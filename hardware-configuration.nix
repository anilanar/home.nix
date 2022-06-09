# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  # required for intel based wifi/bluetooth pci card
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4795a4c0-5040-4002-9109-2d15602a1ada";
    fsType = "ext4";
  };

  fileSystems."/d8a" = {
    device = "/dev/disk/by-uuid/48901b06-253e-4402-b391-7bcce58ffedf";
    fsType = "ext4";
  };

  fileSystems."/win" = {
    device = "/dev/disk/by-uuid/B84655FF4655BF36";
    fsType = "ntfs";
  };

  fileSystems."/d8a-win" = {
    device = "/dev/disk/by-uuid/3D2F14D033F8C61C";
    fsType = "ntfs";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/7662-C11F";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/66789c6a-c33f-442c-8318-e2f269989719"; }];

  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
