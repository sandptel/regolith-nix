{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayland-protocols,
  libdrm,
  libinput,
  cairo,
  pango,
  wayland,
  libGL,
  libxkbcommon,
  pcre2,
  json_c,
  libevdev,
  scdoc,
  wayland-scanner,
  wlroots_0_17,
  systemd,
  enableXWayland ? true,
  systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd,
  trayEnabled ? systemdSupport,
}:

stdenv.mkDerivation (finalAttrs: {
  inherit
    enableXWayland
    systemdSupport
    trayEnabled;

  pname = "sway-regolith";
  version = "1.7-8-ubuntu-jammy";

  src = fetchFromGitHub {
    owner = "regolith-linux";
    repo = "sway-regolith";
    rev = "v${version}";
    hash = "sha256-DK0H4ZXFh1YPvMmT2HzzllWQcrC7y8nLidNw3zlFrTM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
    wayland-scanner
  ];

  buildInputs = [
    cairo
    json_c
    libdrm
    libevdev
    libGL
    libinput
    libxkbcommon
    pango
    pcre2
    wayland
    wayland-protocols
    (wlroots_0_17.override { inherit (finalAttrs) enableXWayland; })
  ];

  mesonFlags = let
    sd-bus-provider = if systemdSupport then "libsystemd" else "basu";
  in [
    (lib.mesonOption "sd-bus-provider" sd-bus-provider)
    (lib.mesonEnable "xwayland" finalAttrs.enableXWayland)
    (lib.mesonEnable "tray" finalAttrs.trayEnabled)
  ];

  meta = {
    description = "I3-compatible Wayland compositor";
    homepage = "https://github.com/regolith-linux/sway-regolith/tree/upstream/v1.10";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "sway-regolith";
    platforms = lib.platforms.linux;
  };
})
