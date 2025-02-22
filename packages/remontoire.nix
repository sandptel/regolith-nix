{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  vala,
  pkg-config,
  json-glib,
  tinysparql,
  gtk3,
  libgee,
  gobject-introspection,
  desktop-file-utils,
  appstream-glib,
  makeWrapper,
  ...
}:

stdenv.mkDerivation rec {
  pname = "remontoire";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "remontoire";
    rev = "v${version}";
    hash = "sha256-9gWSZ58EqTmJTzW84hsSv2Oej4JpYdGqzsyj6qDT3Fo=";
  };

  nativeBuildInputs = [
    makeWrapper
    meson
    ninja
    vala
    pkg-config
    json-glib
    tinysparql
    gtk3
    libgee
    gobject-introspection
    desktop-file-utils
    appstream-glib
  ];

  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share
    cp src/remontoire $out/share 
    cp ../data/org.regolith-linux.remontoire.gschema.xml $out/share
    glib-compile-schemas $out/share/ 
    makeWrapper $out/share/remontoire $out/bin/remontoire --set GSETTINGS_SCHEMA_DIR $out/share
    '';

  meta = {
    description = "A keybinding viewer for i3 and other programs";
    homepage = "https://github.com/regolith-linux/remontoire";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "remontoire";
    platforms = lib.platforms.all;
  };
}
