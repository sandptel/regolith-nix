{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "trawl";
  version = "0.2.5";

  src = fetchFromGitHub {
    owner = "sandptel";
    repo = "trawl";
    rev = "derivation";
    hash = "sha256-/nUvV0tgPzOJ5L+EXw6J/1lgRT+BPnlkv7yzko15o6A";
  };

  cargoHash = "sha256-5kDWFJ6kmzrs5U1uOfmGTLE+z8DGcS+BIv8ZIUU4StA=";

  meta = {
    description = "";
    homepage = "https://github.com/regolith-linux/trawl";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "trawl";
  };
}
