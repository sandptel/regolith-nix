{ lib
, stdenv
, writeTextFile
}:

stdenv.mkDerivation {
  pname = "regolith-xresources";
  version = "1.0.0";
  src = ./.;

  installPhase = ''
    mkdir -p $out/regolith3
    cp -r $src/regolith3 $out
  '';

  meta = with lib; {
    description = "Xresources configuration for Regolith Linux";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
