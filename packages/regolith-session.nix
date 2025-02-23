{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "regolith-session";
  version = "1.1.13-3-debian-bookworm";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-session";
    rev = "v${version}";
    hash = "sha256-Za4OGuFQx9JNbQITXSiSOimv9KPM3/QrodBPhStlmjM=";
  };

  buildPhase = ''
    patchShebangsAuto $src
  '';

  installPhase = ''
    mkdir -p $out
    cp -r $src/usr/* $out
  
    mkdir -p $out/etc
    cp -r $src/etc $out

    # mkdir -p $out/bin
    # cp -r $src/usr/bin $out

    # Make scripts executable
    find $out -type f -name "*.sh" -exec chmod +x {} \;
  '';
  # pathsToLink = [ /bin /usr /etc];

  meta = {
    description = "Configuration and logic for the Regolith desktop session";
    homepage = "https://github.com/regolith-linux/regolith-session";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "regolith-session";
    platforms = lib.platforms.all;
  };
}
