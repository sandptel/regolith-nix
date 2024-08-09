{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.regolith;
in {
  imports= [./packages.nix ./session.nix  ];  

  options.regolith = {
    enable = mkEnableOption "Enable Regolith";
    };

  config = mkIf cfg.enable {
      regolith.packages={
        enable=true;
        extraPackages= with pkgs;[ 
        dbus
        sway
        swayidle
        swaylock
        clipman
        wl-clipboard
        ];
      };
    };
  }