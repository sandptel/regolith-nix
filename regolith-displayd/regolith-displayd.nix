{lib,rustPlatform,fetchFromGitHub,pkg-config,glib,rustc,}:

rustPlatform.buildRustPackage rec {
pname = "regolith-displayd";
version = "3.0";

src = fetchFromGitHub {
owner = "regolith-linux";
repo = "regolith-displayd";
rev = "r3_0";
hash = "sha256-6E3oLlRNuEYrhkT0ENvyYzVvebK8JcSR1ubsEI34X0g=";
};

cargoHash = "sha256-vodqVq58P5Mt1WG1lg+NR4DDmfiDq+H9kZyuA6Em1k4=";

nativeBuildInputs = [pkg-config rustc];
buildInputs = [glib];

  meta = {
    mainProgram = "regolith-displayd";
    description = "Daemon for providing gnome-control-center DisplayConfig DBus bindings for sway. ";
    homepage = "https://github.com/regolith-linux/regolith-displayd";
    license = lib.licenses.gpl3Plus;
  };
}
