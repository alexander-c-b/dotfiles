{ config, pkgs, ... }:

{
  # Boot loader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint     = "/boot/";
    };
    systemd-boot.enable = true;
  };
  boot.supportedFilesystems = [ "zfs" ];

  services.xserver = { 
    wacom.enable = true;
    videoDrivers = [ "nvidia" ];
  };
  networking = {
    useDHCP                   = false;
    interfaces.eno1.useDHCP   = true;
    interfaces.wlp4s0.useDHCP = true;
    networkmanager.enable     = true;
    hostName                  = "z-nixos-desktop";
    hostId                    = "156CA968";
  };
}
