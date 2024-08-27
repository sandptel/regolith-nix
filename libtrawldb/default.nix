
# {
#   pkgs, ...
# }:

let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
  };

  pkgs = import nixpkgs { config = {}; };
in

pkgs.stdenv.mkDerivation {
  pname = "libtrawlb";
  version = "3.2";
  
  src = pkgs.fetchFromGitHub {
    owner = "regolith-linux";
    repo = "libtrawldb";
    rev = "r3_2";
    hash = "sha256-n8/lrm5eOk+Oh+sEJULzUUZ6zFMIkvOgD9dviepQCB0=";
  };

  # src= ./.;

   nativeBuildInputs = with pkgs;[ gcc vala meson ninja pkg-config ];

  buildInputs = with pkgs;[ 
    makeWrapper
    json-glib
    gettext
    gobject-introspection
    intltool
    gtk3
    tracker
    meson
    vala
    cmake
    pkg-config
    libgee
    ninja
    gtk-layer-shell
    glib ];

  mesonFlags = [];

  buildPhase = ''
  patchShebangsAuto $src
  '';
  installPhase = ''
    mkdir -p $out
    meson install --destdir $out
    ninja 
    mkdir -p $out/lib
    cp -r $out/usr/lib $out
    cp -r $out/nix/store/*/* $out
  '';

  meta = {
    mainProgram = "libtrawlb";
    description = "A GTK-based Desktop Executor";
    homepage = "https://github.com/regolith-linux/ilia";
    license = pkgs.lib.licenses.gpl3Plus;
  };
}
