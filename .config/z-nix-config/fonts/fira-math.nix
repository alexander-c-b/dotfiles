{ stdenv, lib, fetchurl }:

let filename = "FiraMath-Regular.otf";
in stdenv.mkDerivation rec {
  name = "fira-math";
  src = fetchurl {
    url = "https://github.com/firamath/firamath/releases/download/v0.3.4/${filename}";
    sha256 = "0nz3hq0m44y3wzcbdmrig6k86slmb53yn845c3qhr32dvp9wna10";
  };

  builder = builtins.toFile "builder.sh" ''
    source $stdenv/setup
    mkdir -p $out/share/fonts
    cp $src $out/share/fonts/${filename}
  '';

  meta = {
    description = "Fira Math Font";
    license = lib.licenses.free;
    platforms = lib.platforms.all;
  };
}
