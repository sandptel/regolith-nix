{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  glib,
}:

rustPlatform.buildRustPackage rec {
  pname = "regolith-powerd";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-powerd";
    rev = "v${version}";
    hash = "sha256-Hu6EhNBClHsh0mrOAfPw848q0czoivoYnpiE9/+drK4=";
  };

  cargoHash = "sha256-mVs3g7ccAGST53I4/7daOm8EJKdKh0mJGhCPFX6rfhs=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    glib
  ];

  meta = {
    description = "Daemon to sync gsd power settings with Regolith on Wayland. Provides idle state functionality and sets power button action";
    homepage = "https://github.com/regolith-linux/regolith-powerd";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "regolith-powerd";
  };
}
