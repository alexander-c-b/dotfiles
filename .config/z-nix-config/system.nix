# vim: set tabstop=8 softtabstop=2 shiftwidth=2 expandtab number relativenumber:
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  homePath = "/home/zander";
  thisSystem = ./. + "/${builtins.readFile /etc/nixos/this-system}.nix";
in rec {
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      thisSystem
    ];

  nix.useSandbox = true;

  # I'm a bad evangelist
  nixpkgs.config.allowUnfree = true;

  # Time zone.
  time.timeZone = "America/New_York";

  # OpenSSH
  services.openssh.enable = true;

  # CUPS printing
  services.printing = {
    enable  = true;
    drivers = let
      lpr         = pkgs.callPackage ./packages/mfcj835dw/lpr.nix { };
      cupswrapper = pkgs.callPackage ./packages/mfcj835dw/cupswrapper.nix {
        mfcj835dwlpr = lpr;
      };
    in [ lpr cupswrapper ];
  };
  services.system-config-printer.enable = true;

  # Scanning
  hardware.sane = {
    enable             = true;
    brscan4.enable     = true;
    brscan4.netDevices = {
      brotherPrinter = {
        ip    = "10.0.0.231";
        model = "MFC-J835DW";
      };
    };
  };

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable  = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable   = true;

  # Application Config
  nixpkgs.config = {
    dwm.patches = let
      fibonacci = builtins.fetchurl {
        url    = "http://dwm.suckless.org/patches/fibonacci/dwm-fibonacci-6.2.diff";
        sha256 = "12y4kknly5irwd6yhqj1zfr3h06hixi2p7ybjymhhhy0ixr7c49d";
      };
      fancybar = builtins.fetchurl {
        url    = "http://dwm.suckless.org/patches/fancybar/dwm-fancybar-6.2.diff";
        sha256 = "0bf55553p848g82jrmdahnavm9al6fzmd2xi1dgacxlwbw8j1xpz";
      };
      noborder = builtins.fetchurl {
        url    = "http://dwm.suckless.org/patches/noborder/dwm-noborderfloatingfix-6.2.diff";
        sha256 = "114xcy1qipq6cyyc051yy27aqqkfrhrv9gjn8fli6gmkr0x6pk52";
      };
      push     = builtins.fetchurl {
        url    = "https://dwm.suckless.org/patches/push/dwm-push-20201112-61bb8b2.diff";
        sha256 = "19ln6q29ds2ifm9i7s0cvvadn7i4s2m65w9zq22gc4w3rsqfqv3w";
      };
    in [ fibonacci fancybar noborder push ];

    # Override dwm with post patch to use my config file.
    packageOverrides = super: let self = super.pkgs; in {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        conf = /home/zander/.config/dwm/config.h;
        # based on pkgs.dwm-git
        postPatch = ''
          cat '${conf}' > config.def.h
        '';
        }
      );
    };
  };

  qt5.platformTheme = "gtk";
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  # System Packages
  environment.systemPackages = (import ./packages.nix pkgs)
    ++ [(import /home/zander/.config/z-nix-config/ghcPackages.nix pkgs)];

  fonts.fonts = with pkgs; [
    ubuntu_font_family
    lmodern
    xits-math
    (pkgs.callPackage ./fonts/times.nix { })
    (pkgs.callPackage ./fonts/fira-math.nix { })
  ];
  fonts.enableFontDir = true;
  fonts.fontconfig.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    autorun = true;
    layout = "us";
    xkbOptions = "eurosign:e";
    desktopManager.xterm.enable   = true;
    windowManager.dwm.enable      = true;
  };

  services.redshift = {
    enable = true;
    temperature.night = 3500;
  };
  location.latitude  =  27.8961111;
  location.longitude = -81.8433333;

  # Users
  users.extraGroups.nixosconf = {
    members = [ "zander" "root" ];
  };
  users.users.zander = {
    isNormalUser = true;
    home         = homePath;
    # "wheel": Enable 'sudo' for the user.
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "lp"
      "zander"
      "nixosconf"
    ];
    shell = pkgs.zsh;
    uid   = 1000;
  };

  environment.shells = [ pkgs.zsh ];
  users.defaultUserShell = pkgs.zsh;

  # Filesystems
  fileSystems = {
    "${homePath}/dev/backup" = {
      device  = "/dev/disk/by-label/ZBACKUP";
      fsType  = "ntfs";
      label   = "z-backup";
      options = [ "nofail" "nosuid" "nodev" "auto" "uid=1000" "gid=1000" ];
    };

    "/mnt/file-server" = {
      device     = "//10.0.0.132/users";
      mountPoint = "/mnt/file-server";
      fsType     = "cifs";
      options    = [
        "_netdev" "x-systemd.mount-timeout=30" "user" "uid=1000" "gid=1000"
        "nofail" "auto" "credentials=${homePath}/.server-credentials"
      ];
    };

    "/mnt/zander-file-server" = {
      device     = "//10.0.0.132/zander";
      mountPoint = "/mnt/zander-file-server";
      fsType     = "cifs";
      options    = [
        "_netdev" "x-systemd.mount-timeout=30" "user" "uid=1000" "gid=1000"
        "nofail" "auto" "credentials=${homePath}/.server-credentials"
      ];
    };
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.03"; # Did you read the comment?

}

