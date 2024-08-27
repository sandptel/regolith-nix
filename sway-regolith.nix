{ system,inputs,config, lib, pkgs, ... }:

with lib;

let
  cfg = config.regolith.sway;
in {
  options.regolith.sway = {
    enable = mkEnableOption "Add sway-regolith and related wm config packages";
    };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      i3status-rust
      mate.mate-polkit
      networkmanagerapplet
      sway-audio-idle-inhibit swaylock swayidle dbus clipman wl-clipboard xwayland
      avizo
      #sway-regolith
      (import ./sway-regolith/default.nix {inherit pkgs;})
      #regolith-wm-config
      (import ./regolith-wm-config/default.nix {inherit pkgs;})
  ];
    };
  }
