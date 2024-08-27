
# {pkgs,...}:
let
  nixpkgs = builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
  };

  pkgs = import nixpkgs { config = {}; };
in

pkgs.stdenv.mkDerivation {
  pname = "regolith-look-default";
  version = "3.1";
  
  src = pkgs.fetchFromGitHub {
    owner = "regolith-linux";
    repo = "i3status-rs_debian";
    rev = "r3_2-ubuntu-jammy";
    hash = "sha256-5BAog0sAWqQaUPdc0Xk/ceIbB+WAJ+mc2bNM/j9ykeU=";
  };
  # src=./.;
  nativeBuildInputs = [

  ];

  buildInputs = with pkgs;[
    
  ];

  buildPhase = ''
  # chmod -R +x $src
  patchShebangsAuto $src
  '';

# target/release/i3status-rs /usr/bin/
# config.toml /etc/regolith/i3status-rust/
# files/* /usr/share/i3status-rust/
# Configuration file '/run/current-system/sw/etc/regolith/i3status-rust/config.toml' not found

   installPhase = ''
    # Install your scripts or binaries
    
    mkdir -p $out/etc/regolith/i3status-rust
    cp -r $src/examples/* $out/etc/regolith/i3status-rust

  '';

    pathsToLink = [ /bin /usr /lib];


  meta = {
    # mainProgram = "";
    description = "look-default";
    homepage = "https://github.com/regolith-linux/regolith-look-default";
    license = pkgs.lib.licenses.gpl3Plus;
  };
}
