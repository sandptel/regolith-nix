
{
  pkg-config,
  libgee,
  ninja,
  gtk-layer-shell,
  pkgs,
  lib,
  stdenv,
  makeWrapper,
  fetchgit,
  json-glib,
  gettext,
  gobject-introspection,
  intltool,
  gtk3,
  tracker,
  meson,
  vala,
  cmake,
}:

stdenv.mkDerivation {
  pname = "ilia";
  version = "3.1";
  
  src = pkgs.fetchFromGitHub {
    owner = "regolith-linux";
    repo = "ilia";
    rev = "r3_1-ubuntu-jammy";
    hash = "sha256-4MKVwaepLOaxHFSwiks5InDbKt+B/Q2c97mM5yHz4eU=";
  };


  nativeBuildInputs = [

  ];

  buildInputs = [
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
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    cp src/ilia $out/share
    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/share/glib-2.0/schemas/
    glib-compile-schemas --targetdir=$out/share/glib-2.0/schemas $src/data
    makeWrapper $out/share/ilia $out/bin/ilia --set GSETTINGS_SCHEMA_DIR $out/share/gsettings-schemas/ilia-3.1/glib-2.0/schemas
  '';

  meta = {
    mainProgram = "ilia";
    description = "A GTK-based Desktop Executor";
    homepage = "https://github.com/regolith-linux/ilia";
    license = lib.licenses.gpl3Plus;
  };
}
