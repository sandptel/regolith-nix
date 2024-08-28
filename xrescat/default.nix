{ pkgs,...}:
# let
#   nixpkgs = builtins.fetchTarball {
#     url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
#   };
#     pkgs = import nixpkgs { config = {}; };
#     extraConfig = "default config content";
# in
pkgs.stdenv.mkDerivation {
  pname = "xrescat";
  version = "v1.0";
  
  src = pkgs.fetchFromGitHub {
    owner = "regolith-linux";
    repo = "xrescat";
    rev = "e8e261441682244112b2020e2ad102768e6ba3fd";
    sha256 = "0mMcoNNkaFO6O0F8HjIA8Q8MtfSHLeXY9cGkVd83Vls=";
  };
  
  buildInputs = [
pkgs.gnumake
    pkgs.gcc
    pkgs.gdb
    pkgs.xorg.libX11.dev
    pkgs.SDL2.dev
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
}