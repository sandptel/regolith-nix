{
  pkgs,
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "xrescat";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "xrescat";
    rev = "e8e261441682244112b2020e2ad102768e6ba3fd";
    sha256 = "0mMcoNNkaFO6O0F8HjIA8Q8MtfSHLeXY9cGkVd83Vls=";
  };

  buildInputs = with pkgs;[
    gnumake
    gcc
    gdb
    xorg.libX11.dev
    SDL2.dev
  ];
  buildPhase= ''
  make
  '';
  installPhase= ''
  mkdir -p $out
  make install DESTDIR=$out

  mkdir -p $out/bin
  mkdir -p $out/share
  cp -r $out/usr/* $out/

  '';

  meta = {
    description = "Cat Xresources";
    homepage = "https://github.com/regolith-linux/xrescat";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "xrescat";
    platforms = lib.platforms.all;
  };
}
