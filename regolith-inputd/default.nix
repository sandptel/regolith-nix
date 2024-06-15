{pkgs ? import <nixpkgs> {}}:

pkgs.rustPlatform.buildRustPackage rec {
pname = "regolith-inputd";
version = "3.1";

src = pkgs.fetchFromGitHub {
owner = "regolith-linux";
repo = "regolith-inputd";
rev = "r3_1";
hash = "sha256-PX9lWeAfJ79zEhXEKFTryf780JcoY7k6XRSxzHM1WWw=";
};

cargoHash = "sha256-q+s/XDQtHy86NBRc9EwmnCldEF4FLM599kSwAwlxgY8=";

nativeBuildInputs = with pkgs;[pkg-config rustc];
buildInputs = with pkgs;[glib];

  meta = {
    mainProgram = "regolith-inputd";
    description = "Input management daemon for regolith wayland session. ";
    homepage = "https://github.com/regolith-linux/regolith-inputd";
    license = pkgs.lib.licenses.gpl3Plus;
  };
}
