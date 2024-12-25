
{pkgs,...}:

pkgs.stdenv.mkDerivation {
  pname = "i3status-rs";
  version = "3.2";
  
  src = pkgs.fetchFromGitHub {
    owner = "regolith-linux";
    repo = "i3status-rs_debian";
    rev = "main";
    hash = "sha256-6AdgA9sNZHxgzhNVnH8flP3OYB3t0cRSQREPR5cYnMg=";
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

    mkdir -p $out/usr/share/i3status-rust/
    cp -r $src/files/* $out/usr/share/i3status-rust/

  '';

    # pathsToLink = [ /bin /usr /lib];


  meta = {
    # mainProgram = "";
    description = "i3status config only";
    homepage = "https://github.com/regolith-linux/regolith-look-default";
    license = pkgs.lib.licenses.gpl3Plus;
  };
}
