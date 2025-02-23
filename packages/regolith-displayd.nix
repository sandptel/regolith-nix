{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "regolith-displayd";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-displayd";
    rev = "v${version}";
    hash = "sha256-WUjUs9h+zzq9lFqnEHvsCJ322HVPZldUOt0LZdKbUFs=";
  };

  cargoHash = "sha256-SJ99TqEMMyDGqDwJ3x7EJ/jXe0iNvctTJcPnO5uVXW0=";
  
  postInstall = ''
    install -Dm644 data/regolith-init-kanshi.service $out/lib/systemd/user/regolith-init-kanshi.service
    install -Dm644 data/regolith-init-displayd.service $out/lib/systemd/user/regolith-init-displayd.service
  '';

  meta = {
    description = "Daemon for providing gnome-control-center DisplayConfig DBus bindings for sway";
    homepage = "https://github.com/regolith-linux/regolith-displayd";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "regolith-displayd";
  };
}
