{ config, pkgs, ... }:

{
  # Boot loader
  boot.loader = {
    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint     = "/boot";
    };
    grub = {
      enable      = true;
      useOSProber = true;
      efiSupport  = true;
      zfsSupport  = true;
      devices     = [ "nodev" ];
      version     = 2;
    };
  };
  boot.supportedFilesystems = [ "zfs" ];

  # Bumblebee: manage powersaving when not gaming
  hardware.bumblebee.enable = true;

  # Hibernation
  # hibernate instead of sleep (also preserves wifi)
  systemd.sleep.extraConfig = ''
    [Sleep]
    AllowSuspend=yes
    SuspendState=disk
    AllowHibernation=yes
  '';

  # Hibernate when power runs out
  services.upower = {
    enable = true;
    criticalPowerAction = "Hibernate";
  };

  # Networking
  networking = {
    networkmanager.enable      = true;
    useDHCP                    = false;
    interfaces.enp60s0.useDHCP = true;
    interfaces.wlo1.useDHCP    = true;
    hostName                   = "z-nixos-msi-laptop";
    hostId                     = "04af080a";
  };

  # Global keybindings
  services.actkbd = {
    enable = true;

    bindings = let light = "/run/current-system/sw/bin/light"; in [
      # Brightness up
      { keys = [ 225 ]; events = [ "key" ]; command = "${light} -A 5"; }
      # Brightness down
      { keys = [ 224 ]; events = [ "key" ]; command = "${light} -U 5"; }
    ];
  };

  services.xserver = {
    # Enable touchpad support.
    libinput = {
      enable           = true;
      tapping          = true;
      naturalScrolling = true;
      scrollMethod     = "twofinger";
    };
  };
}
