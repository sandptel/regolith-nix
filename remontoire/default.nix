{ pkgs, ...}:

pkgs.stdenv.mkDerivation {
  pname = "remontoire";
  version = "3.1";

  src = pkgs.fetchFromGitHub {
    owner = "regolith-linux";
    repo = "remontoire";
    rev = "r3_1";
    hash = "sha256-Cb6tzTGZdQA9oA04DO/xLBw5F+FRj5BM2Aa62YWGmZA=";
  };

buildInputs = with pkgs;[
    ninja
    meson
    makeWrapper
    
  ];

 propagatedBuildInputs = with pkgs;[
    glib
    vala
    pkg-config
    json-glib
    tracker
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
    mainProgram = "remontoire";
    description = "A GTK-based Desktop Executor";
    homepage = "A keybinding viewer for i3 and other programs. ";
    license = pkgs.lib.licenses.gpl3Plus;
  };
  
}
