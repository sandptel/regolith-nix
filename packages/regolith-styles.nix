{ lib
, stdenv
, fetchFromGitHub
,
}:

stdenv.mkDerivation rec {
  pname = "regolith-styles";
  version = "2.4.24-1";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-styles";
    rev = "debian/${version}";
    hash = "sha256-WPR66yngSbLWzEWmnQfNJOqH72+Q8ocHPa4b8IADqVI=";
  };

  installPhase = ''
    mkdir -p $out/etc/regolith/styles
    mkdir -p $out/bin
    cp -r . $out/etc/regolith/styles
    cp -r $src/Xresources/* $out/etc/regolith/styles
    cp -r $src/regolith-look $out/bin/regolith-look
  '';

  meta = {
    description = "A convention for organizing Xresource-based theme data";
    homepage = "https://github.com/regolith-linux/regolith-styles/tree/master";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "regolith-styles";
    platforms = lib.platforms.all;
  };
}
