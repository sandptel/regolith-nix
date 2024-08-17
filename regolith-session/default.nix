
{pkgs,...}:
# let
#   nixpkgs = builtins.fetchTarball {
#     url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
#   };

#   pkgs = import nixpkgs { config = {}; };
# in

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
    
    mkdir -p $out
    cp -r $src/usr/* $out
  
    mkdir -p $out/etc
    cp -r $src/etc $out

    substituteInPlace $out/bin/* \
    --replace-quiet /usr/lib/regolith/regolith-session-common.sh $out/lib/regolith/regolith-session-common.sh \

  '';

  # postInstall = ''
  
    
  #   # --replace-fail "a string containing spaces" "some other text" \
  #   # --subst-var someVar
  # '';

  meta = {
    # mainProgram = "";
    description = "Session files and Executables";
    homepage = "https://github.com/regolith-linux/regolith-session";
    license = pkgs.lib.licenses.gpl3Plus;
  };
}
