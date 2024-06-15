{ python311,
fetchFromGitHub,lib,}:

python311.pkgs.buildPythonApplication {
  pname = "rofication";
  version = "3.1";
  
  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "regolith-rofication";
    rev = "r3_1";
    hash = "sha256-9UKKENrEicQKBWLczQFHmfsa9yxoKTGd+dTDZ/YdkS0=";
  };
  
 propagatedBuildInputs = with python311.pkgs; [dbus-python pygobject3];
  installPhase= ''
  mkdir -p $out/bin
  cp -r ./  $out/bin
  '';
  meta = {
    mainProgram = "rofication";
    description = " Notification system that provides a Rofi front-end ";
    homepage = "https://github.com/regolith-linux/regolith-rofication";
    license = lib.licenses.gpl3Plus;
  };
}
