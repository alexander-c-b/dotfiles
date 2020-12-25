pkgs:

let stPath = /home/zander/.config/z-nix-config/packages/st-lukesmithxyz.nix;
in with pkgs; [
  # Interface
  dmenu
  (pkgs.callPackage stPath {})
  setroot # for background
  rxvt-unicode

  # X.org
  xorg.xmodmap
  xbindkeys
  xdotool
  xclip

  # Command Line Tools
  dash
  neovim
  ranger
  trash-cli
  wget
  git
  htop
  maim
  feh
  killall
  direnv
  file
  tree

  # Other Utilities
  qutebrowser
  zathura
  firefox
  gnumeric
  vlc
  gimp
  imagemagick7Big
  zoom-us
  simple-scan
  (texlive.combine {
    inherit (texlive) scheme-context context-gnuplot;
  })
  lilypond
  fontconfig
  light
  (python38.withPackages (ps: with ps; [sympy ipython]))

  # Audio
  ffmpeg
  clementine
  audacity

  # Internet
  networkmanagerapplet
]
