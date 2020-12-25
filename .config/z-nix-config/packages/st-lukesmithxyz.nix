{ stdenv, fetchFromGitHub, pkgconfig, libX11, libXext, libXft, fontconfig, harfbuzz }:

with stdenv.lib;

let
  version = "0.8.2";
  name = "st-lukesmithxyz-${version}";
in stdenv.mkDerivation {
  inherit name;

  src = fetchFromGitHub {
    owner  = "LukeSmithxyz";
    repo   = "st";
    rev    = "8ab3d03681479263a11b05f7f1b53157f61e8c3b";
    sha256 = "1brwnyi1hr56840cdx0qw2y19hpr0haw4la9n0rqdn0r2chl8vag";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libX11 libXft libXext fontconfig harfbuzz ]; 

  installPhase = ''
    sed -i '/tic /d' Makefile
    make install PREFIX=$out
  '';

  meta = {
    homepage = "https://github.com/lukesmithxyz/st";
    description = ''
      The suckless terminal (st) with some additional features that make it 
      literally the best terminal emulator ever.
    '';
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
