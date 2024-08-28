{ pkgs, extraConfig ? "", ... }:

# let
#   nixpkgs = builtins.fetchTarball {
#     url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
#   };
#     pkgs = import nixpkgs { config = {}; };
#     extraConfig = "default config content";
# in

pkgs.stdenv.mkDerivation {
  pname = "regolith-ftue";
  version = "3.1";

  src = pkgs.fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-ftue";
    rev = "r3_2";
    hash = "sha256-dFlALYZNCLBfSzWOh/frUpjC3Tnvsd4HYG2nCOWNPJE=";
  };

  nativeBuildInputs = [];

  buildInputs = with pkgs; [];

  buildPhase = ''
    patchShebangsAuto $src
  '';

  installPhase = ''
    mkdir -p $out/usr/share/regolith-ftue
    cp -r $src/regolith-init-term-profile $out/usr/share/regolith-ftue

    mkdir -p $out/bin
    cp -r $src/regolith-ftue $out/bin

    substituteInPlace $out/bin/* \
      --replace-quiet /usr /run/current-system/sw/usr \
      --replace-quiet /etc /run/current-system/sw/etc \
      --replace-quiet /bin /run/current-system/sw/bin \
  '';

  pathsToLink = [ /bin /usr];

  meta = {
    description = "Logic and assets for Regolith first-time user experience. ";
    homepage = "https://github.com/regolith-linux/regolith-wm-config";
    license = pkgs.lib.licenses.gpl3Plus;
  };
}
