{
  lib,
  stdenv,
  fetchFromGitHub,
  rsync,
  excludeFiles ? [],
}:

stdenv.mkDerivation rec {
  pname = "regolith-wm-config";
  version = "4.11.8";

  src = fetchFromGitHub {
    owner = "sandptel";
    repo = "regolith-wm-config";
    rev = "nix";
    hash = "sha256-rxF4uEOBWYnj9oQY6Aq/OPeT9IyPJGwyNvkskTapvnw=";
  };

  nativeBuildInputs = [ rsync ];

  buildPhase = ''
    patchShebangsAuto $src
  '';

  installPhase = ''
    mkdir -p $out/share $out/etc $out/bin
    
    cd $src
    # Copy files maintaining the correct structure, excluding specified files
    if [ -d usr/share ]; then
      ${rsync}/bin/rsync -av --exclude=${lib.concatStringsSep " --exclude=" excludeFiles} usr/share/* $out/share/
    fi
    if [ -d etc ]; then
      ${rsync}/bin/rsync -av --exclude=${lib.concatStringsSep " --exclude=" excludeFiles} etc/* $out/etc/
    fi
    if [ -d scripts ]; then
      ${rsync}/bin/rsync -av --exclude=${lib.concatStringsSep " --exclude=" excludeFiles} scripts/* $out/bin/
    fi
  '';

  postInstall = ''
    
  '';

  meta = {
    description = "Configuration files related to window manager in X11 and Wayland";
    homepage = "https://github.com/regolith-linux/regolith-wm-config";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "regolith-wm-config";
    platforms = lib.platforms.all;
  };
}
