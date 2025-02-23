{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "regolith-wm-config";
  version = "4.11.8";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-wm-config";
    rev = "v${version}";
    hash = "sha256-1CJuj6a7lyon5/U/B8CvQZn5VHEKHNUcTMWsqDzstRo=";
  };

  buildPhase = ''
    patchShebangsAuto $src
  '';

  installPhase = ''
    mkdir -p $out/share $out/etc $out/bin
    cp -r $src/usr/share/* $out/share
    cp -r $src/etc/* $out/etc
    cp -r $src/scripts/* $out/bin
  '';

  meta = {
    description = "Configuration files related to window manager in X11 and Wayland";
    homepage = "https://github.com/regolith-linux/regolith-wm-config";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "regolith-wm-config";
    platforms = lib.platforms.all;
  };
}
