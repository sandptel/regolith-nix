{ pkgs}:
# let
#   nixpkgs = builtins.fetchTarball {
#     url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
#   };

#   pkgs = import nixpkgs { config = {}; };
# in
pkgs.rustPlatform.buildRustPackage {
  pname = "trawl";
  version = "3.1";

  src = pkgs.fetchFromGitHub {
    owner = "sandptel";
    repo = "trawl";
    rev = "master";
    hash = "sha256-s5sf+082qZACkeoLprOjsCUEd3RKP062qhGPaX5oy/Q=";
  };

cargoHash = "sha256-Nnc+j7mBRibPr33mOb9PvMq4lula23iZCuUqB+FLaAY=";

buildInputs = with pkgs;[ glib pkg-config ];

  meta = {
    mainProgram = "trawl";
    description = "Simple Xresources style linux based configuration system that is independent of distro / display backend (Wayland / X11 / etc).";
    homepage = "https://github.com/regolith-linux/trawl";
    license = pkgs.lib.licenses.gpl3Plus;
  };
  
}