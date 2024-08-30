{ pkgs, ...}:
# let
#   nixpkgs = builtins.fetchTarball {
#     url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
#   };

#   pkgs = import nixpkgs { config = {}; };
# in

pkgs.python311.pkgs.buildPythonApplication {
  pname = "i3-swap-focus";
  version = "3.1";
  
  src = pkgs.fetchFromGitHub {
    owner = "regolith-linux";
    repo = "i3-swap-focus";
    rev = "r3_2";
    hash = "sha256-ge4Xh6Je06uogxTXbEw9WQY8qo0Vn/MPseAgxsE4VYA=";
  };
  
 propagatedBuildInputs = with pkgs.python311.pkgs; [i3ipc];
  # installPhase= ''
  # mkdir -p $out/bin
  # cp -r ./  $out/bin
  # '';

  meta = {
    mainProgram = "i3-swap-focus";
    description = " Notification system that provides a Rofi front-end ";
    homepage = "https://github.com/regolith-linux/regolith-rofication";
    license = pkgs.lib.licenses.gpl3Plus;
  };
}
