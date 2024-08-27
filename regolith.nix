{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.regolith;
in {
  imports= [ ./session.nix ./packages.nix ];  

  options.regolith = {
    enable = mkEnableOption "Enable Regolith";
    };

  config = mkIf cfg.enable {
     environment.systemPackages = with pkgs; [
        (import ./sway-regolith/default.nix {inherit pkgs;})
        swaylock swayidle dbus clipman wl-clipboard xwayland 
  ];
    regolith.session.enable=true;
    };
  }