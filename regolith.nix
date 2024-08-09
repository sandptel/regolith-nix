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
    # programs.xwayland.package=true;
    programs.sway.enable=true;
    programs.sway.xwayland.enable=true;
    programs.sway.extraPackages=with pkgs; [ swaylock swayidle dbus clipman wl-clipboard xwayland ];
    regolith.packages={
        enable=true;
      };
    };
  }