{ pkgs ? import <nixpkgs> {} }:

let
  regolith-packages = import ./packages { inherit pkgs; };
  
  # Get all packages including their dependencies
  regolith-pkgs = [
    regolith-packages.ilia
    regolith-packages.regolith-powerd
    regolith-packages.regolith-displayd
    regolith-packages.regolith-inputd
    regolith-packages.regolith-ftue
    regolith-packages.xrescat
    regolith-packages.rofication
    regolith-packages.remontoire
    regolith-packages.trawl
    regolith-packages.i3xrocks
    regolith-packages.libtrawlb
    regolith-packages.regolith-look-extra
    regolith-packages.i3status-rs
    regolith-packages.sway-regolith
    regolith-packages.regolith-session
    regolith-packages.regolith-look-default
    regolith-packages.regolith-wm-config
  ];

  # Collect all build inputs recursively
  all-inputs = builtins.concatMap 
    (p: if builtins.hasAttr "buildInputs" p then p.buildInputs ++ [p] else [p]) 
    regolith-pkgs;
in
pkgs.buildFHSEnv {
  name = "regolith-environment";
  
  targetPkgs = pkgs: with pkgs; [
    # Basic system utilities
    networkmanagerapplet
    avizo
    mate.mate-polkit
    bash
    coreutils
    gtk3
    glib
  ];

  multiPkgs = pkgs: all-inputs;

  extraOutputsToInstall = [ "usr" "etc" "lib"];

  # profile = ''
  #   export REGOLITH_PATH=/usr/share/regolith
  #   export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share/regolith
  # '';

  runScript = "${pkgs.fish}/bin/fish";
} 