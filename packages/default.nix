{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
}:

stdenv.mkDerivation rec {
  pname = "ilia";
  version = "0.15.1";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "ilia";
    rev = "v${version}";
    hash = "sha256-E6I8NpIhzhmXj8AoX2tsiAl4pyuOyc+4+U6TOaSrBVA=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  meta = {
    description = "A GTK-based Desktop Executor";
    homepage = "https://github.com/regolith-linux/ilia";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "ilia";
    platforms = lib.platforms.all;
  };
}
