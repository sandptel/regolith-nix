{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "regolith-look-extra";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-look-extra";
    rev = "v${version}";
    hash = "sha256-DHou7BB8mem/CkGs4YEYbxQ95HRMUxGw1E59U9U9gTo=";
  };

  installPhase = ''
    mkdir -p $out/share
    cp -r $src/usr/share/* $out/share
  '';

  meta = {
    description = "Additional Looks for the Regolith Desktop";
    homepage = "https://github.com/regolith-linux/regolith-look-extra";
    license = lib.licenses.gpl3Plus; 
    maintainers = with lib.maintainers; [ ];
    mainProgram = "regolith-look-extra";
    platforms = lib.platforms.all;
  };
}