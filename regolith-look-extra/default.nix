
{pkgs,...}:
# let
#   nixpkgs = builtins.fetchTarball {
#     url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
#   };

#   pkgs = import nixpkgs { config = {}; };
# in
pkgs.stdenv.mkDerivation {
  pname = "regolith-look-extra";
  version = "3.1";
  
  src = pkgs.fetchFromGitHub {
    owner = "sandptel";
    repo = "regolith-look-extra";
    rev = "master";
    hash = "sha256-lYN0XNrfQx+gicu2taMPOI1g9ZNKlWv9GwAxa5MvQP8=";
  };

   installPhase = ''
    # Install your scripts or binaries

    mkdir -p $out/usr/share/regolith-look
    cp -r $src/usr $out
  
    # substituteInPlace $out/usr/share/regolith-look/*/*/ \
    # --replace-quiet /usr /run/current-system/sw/usr \

  '';

    pathsToLink = [ /bin /usr /lib];


  meta = {
    # mainProgram = "";
    description = "Default Regolith Xresource definitions for the desktop. ";
    homepage = "https://github.com/regolith-linux/regolith-look-default";
    license = pkgs.lib.licenses.gpl3Plus;
  };
}
