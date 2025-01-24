{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
}:

rustPlatform.buildRustPackage rec {
  pname = "regolith-inputd";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-inputd";
    rev = "v${version}";
    hash = "sha256-PX9lWeAfJ79zEhXEKFTryf780JcoY7k6XRSxzHM1WWw=";
  };

  cargoHash = "sha256-6dlpuQSfxFnam4F5QSoqs1vi7EqY8MraRkTm4iQUSR4=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  meta = {
    description = "Input management daemon for regolith wayland session";
    homepage = "https://github.com/regolith-linux/regolith-inputd";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "regolith-inputd";
  };
}
