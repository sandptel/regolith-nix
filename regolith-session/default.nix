
{pkgs,...}:
pkgs.stdenv.mkDerivation {
  pname = "regolith-session";
  version = "3.1";
  
  src = ./.;

  nativeBuildInputs = [

  ];

  buildInputs = with pkgs;[
    
  ];

  buildPhase = ''
  # chmod -R +x $src
  patchShebangsAuto $src
  '';

   installPhase = ''
    # Install your scripts or binaries
    mkdir -p $out/bin
    cp -r $src/usr/bin $out/bin
    cp -r * $out
    # cp -r * $out

  '';

  # postInstall = ''
  #   mkdir -p $out/share/glib-2.0/schemas/
  #   glib-compile-schemas --targetdir=$out/share/glib-2.0/schemas $src/data
  #   makeWrapper $out/share/ilia $out/bin/ilia --set GSETTINGS_SCHEMA_DIR $out/share/gsettings-schemas/ilia-3.1/glib-2.0/schemas
  # '';

  meta = {
    # mainProgram = "";
    description = "Session files and Executables";
    homepage = "https://github.com/regolith-linux/regolith-session";
    license = pkgs.lib.licenses.gpl3Plus;
  };
}
