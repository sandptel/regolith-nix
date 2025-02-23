{ lib, stdenv, fetchFromGitHub, substituteAll, swaybg
, meson, ninja, pkg-config, wayland-scanner, scdoc
, libGL, wayland, libxkbcommon, pcre2, json_c, libevdev
, pango, cairo, libinput, gdk-pixbuf, librsvg
, wlroots_0_17, wayland-protocols, libdrm
, nixosTests
, pkgs
, makeWrapper
# Used by the NixOS module:
, isNixOS ? false
, enableXWayland ? true, xorg
, systemdSupport ? lib.meta.availableOn stdenv.hostPlatform systemd, systemd
, trayEnabled ? systemdSupport
}:
let
  nixpkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/a3ed7406349a9335cb4c2a71369b697cecd9d351.tar.gz";
    sha256 = "1qmbd98ywmywsacr7b4b17k7pyvmhmlq1avci92ahwx1frq00g1w";
  }) {
    system = "x86_64-linux";
  };

  wlroots_0_15 = nixpkgs.wlroots_0_17;

  libtrawldb = pkgs.callPackage ../packages/libtrawldb.nix {};
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sway-unwrapped";
  version = "1.9";

  inherit enableXWayland isNixOS systemdSupport trayEnabled;
  src = fetchFromGitHub {
    owner = "swaywm";
    repo = "sway";
    rev = finalAttrs.version;
    hash = "sha256-/6+iDkQfdLcL/pTJaqNc6QdP4SRVOYLjfOItEu/bZtg=";
  };

  patches = [
    ./01-regolith-trawl.patch  
    ./load-configuration-from-etc.patch
    ./02-version-fix.patch
    ./03-disable-wallpaper
    ./04-dbus-tray
    ./05-remove-config

    (substituteAll {
      src = ./fix-paths.patch;
      inherit swaybg;
    })

  ] ++ lib.optionals (!finalAttrs.isNixOS) [
    # References to /nix/store/... will get GC'ed which causes problems when
    # copying the default configuration:
    ./sway-config-no-nix-store-references.patch
  ] ++ lib.optionals finalAttrs.isNixOS [
    # Use /run/current-system/sw/share and /etc instead of /nix/store
    # references:
    ./sway-config-nixos-paths.patch
  ];

  strictDeps = true;
  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
   libtrawldb meson ninja pkg-config wayland-scanner scdoc
   makeWrapper
  ];

  buildInputs = [
    libGL wayland libxkbcommon pcre2 json_c libevdev
    pango cairo libinput gdk-pixbuf librsvg
    wayland-protocols libdrm
    (wlroots_0_17.override { inherit (finalAttrs) enableXWayland; })
  ] ++ lib.optionals finalAttrs.enableXWayland [
    xorg.xcbutilwm
  ];

  runtimeDependencies = [
    libtrawldb
  ];

  mesonFlags = let
    inherit (lib.strings) mesonEnable mesonOption;

    # The "sd-bus-provider" meson option does not include a "none" option,
    # but it is silently ignored iff "-Dtray=disabled".  We use "basu"
    # (which is not in nixpkgs) instead of "none" to alert us if this
    # changes: https://github.com/swaywm/sway/issues/6843#issuecomment-1047288761
    # assert trayEnabled -> systemdSupport && dbusSupport;

    sd-bus-provider =  if systemdSupport then "libsystemd" else "basu";
    in [
      (mesonOption "sd-bus-provider" sd-bus-provider)
      (mesonEnable "xwayland" finalAttrs.enableXWayland)
      (mesonEnable "tray" finalAttrs.trayEnabled)
    ];

  passthru.tests.basic = nixosTests.sway;

  postFixup = let
    libraryPath = lib.makeLibraryPath [ libtrawldb ];
  in ''
    wrapProgram $out/bin/sway \
      --prefix LD_LIBRARY_PATH : "${libraryPath}"
  '';

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
    license     = lib.licenses.mit;
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ primeos synthetica ];
    mainProgram = "sway";
  };
})