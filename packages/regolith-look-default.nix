{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "regolith-look-default";
  version = "0.8.3";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-look-default";
    rev = "v${version}";
    hash = "sha256-Q2/lHkMjdcTg9/bf0qiWskidqPuPXS1asBn6mOEp4kA=";
  };

  installPhase = ''
    mkdir -p $out/share
    cp -r $src/usr/share/* $out/share
  '';

  meta = {
    description = "Default Regolith Xresource definitions for the desktop";
    homepage = "https://github.com/regolith-linux/regolith-look-default";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "regolith-look-default";
    platforms = lib.platforms.all;
  };
}
