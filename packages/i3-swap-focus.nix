{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "i3-swap-focus";
  version = "0.4.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "i3-swap-focus";
    rev = "v${version}";
    hash = "sha256-NTNUpiS0ABGjuGsiuSWKgOuQ+rOQQnh8Oqe77D4xnbc=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  dependencies = with python3.pkgs; [
    i3ipc
  ];

  # pythonImportsCheck = [
  #   "i3_swap_focus"
  # ];

  meta = {
    description = "I3/sway script to toggle between last windows";
    homepage = "https://github.com/regolith-linux/i3-swap-focus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "i3-swap-focus";
  };
}
