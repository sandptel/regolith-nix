{ pkgs-sway }:
let
  # nixpkgs = builtins.fetchTarball {
  #   url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
  # };
systemdSupport = true;
libtrawldb= (import ../libtrawldb/default.nix{inherit pkgs;});
  # pkgs = import nixpkgs { config = {}; };
  # todo | easy  --> Apply an overlay to solve this
  pkgs= pkgs-sway;
in
pkgs.stdenv.mkDerivation (finalAttrs: {
  pname = "sway-regolith";
  version = "1.9";
  enableXWayland = true;
  isNixOS = false;
  trayEnabled = true;
  src = pkgs.fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = "v1.9";
    hash = "sha256-/6+iDkQfdLcL/pTJaqNc6QdP4SRVOYLjfOItEu/bZtg=";
  };

  patches = [
    ./load-configuration-from-etc.patch
    ./01-regolith-trawl.patch
    ./02-version-fix.patch
    ./03-disable-wallpaper
    ./04-dbus-tray
    ./05-remove-config

    (pkgs.substituteAll {
      src = ./fix-paths.patch;
      swaybg = pkgs.swaybg;
    })

  ] ++ pkgs.lib.optionals (!finalAttrs.isNixOS) [
    ./sway-config-no-nix-store-references.patch
  ] ++ pkgs.lib.optionals finalAttrs.isNixOS [
    ./sway-config-nixos-paths.patch
  ];

  strictDeps = true;
  depsBuildBuild = [
    pkgs.pkg-config
  ];

  nativeBuildInputs = [
    pkgs.meson pkgs.ninja pkgs.pkg-config pkgs.wayland-scanner pkgs.scdoc
  ];

  buildInputs = [
    pkgs.pcre
    libtrawldb
    pkgs.cmake
    pkgs.libGL pkgs.wayland pkgs.libxkbcommon pkgs.pcre2 pkgs.json_c pkgs.libevdev
    pkgs.pango pkgs.cairo pkgs.libinput pkgs.gdk-pixbuf pkgs.librsvg
    pkgs.wayland-protocols pkgs.libdrm
    (pkgs.wlroots.override { enableXWayland = finalAttrs.enableXWayland; })
  ] ++ pkgs.lib.optionals finalAttrs.enableXWayland [
    pkgs.xorg.xcbutilwm
  ];

  mesonFlags = let
    inherit (pkgs.lib.strings) mesonEnable mesonOption;
    # sd-bus-provider = if systemdSupport then "libsystemd" else "basu";
    sd-bus-provider = if systemdSupport then "libsystemd" else "basu";
    in [
      (mesonOption "sd-bus-provider" sd-bus-provider)
      (mesonEnable "xwayland" finalAttrs.enableXWayland)
      (mesonEnable "tray" finalAttrs.trayEnabled)
    ];

  passthru.tests.basic = pkgs.nixosTests.sway;

  meta = {
    description = "An i3-compatible tiling Wayland compositor";
    longDescription = ''
      Sway is a tiling Wayland compositor and a drop-in replacement for the i3
      window manager for X11. It works with your existing i3 configuration and
      supports most of i3's features, plus a few extras.
      Sway allows you to arrange your application windows logically, rather
      than spatially. Windows are arranged into a grid by default which
      maximizes the efficiency of your screen and can be quickly manipulated
      using only the keyboard.
    '';
    homepage    = "https://swaywm.org";
    changelog   = "https://github.com/swaywm/sway/releases/tag/${finalAttrs.version}";
    license     = pkgs.lib.licenses.mit;
    platforms   = pkgs.lib.platforms.linux;
    maintainers = with pkgs.lib.maintainers; [ pkgs.primeos pkgs.synthetica ];
    mainProgram = "sway";
  };
})