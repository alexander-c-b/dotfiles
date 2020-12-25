{ stdenv ? (import <nixpkgs> {}).stdenv, lib ? (import <nixpkgs> {}).lib }:

stdenv.mkDerivation {
  name = "times";
  src  = ./times;
  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup
    mkdir -p $out/share/fonts
    cp $src/* $out/share/fonts/
  '';

  meta = {
    description = "Times New Roman Font";
    license = lib.licenses.unfree;
    platforms = lib.platforms.all;
  };
}
