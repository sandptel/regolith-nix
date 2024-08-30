
{pkgs,...}:
# let
#   nixpkgs = builtins.fetchTarball {
#     url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
#   };

#   pkgs = import nixpkgs { config = {}; };
# in

pkgs.stdenv.mkDerivation {
  pname = "regolith-look-default";
  version = "3.1";
  
  src = pkgs.fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-look-default";
    rev = "r3_2";
    hash = "sha256-219VC5Tg9erTWktFv0BiNIeWXzNemngELKpTWWWUKSw=";
  };
  # src=./.;
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
    mkdir -p $out/usr/share/regolith-look/default/
    cp -r $src/usr $out
  
    # mkdir -p $out/etc
    # cp -r $src/etc $out

    # mkdir -p $out/bin
    # cp -r $src/usr/bin $out

    substituteInPlace $out/usr/share/regolith-look/default_loader.sh \
    --replace-quiet /usr /run/current-system/sw/usr \
    --replace-quiet "#! /bin/bash" "#!/usr/bin/env bash" \

    patchShebangsAuto $out/usr/share/regolith-look

  '';

    pathsToLink = [ /bin /usr /lib];


  meta = {
    # mainProgram = "";
    description = "Default Regolith Xresource definitions for the desktop. ";
    homepage = "https://github.com/regolith-linux/regolith-look-default";
    license = pkgs.lib.licenses.gpl3Plus;
  };
}
