{ system, inputs, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.regolith.sway;
in {
  options.regolith.sway = {
    enable = mkEnableOption "Add sway-regolith and related wm config packages";
    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = "Extra configuration to be added to sway-regolith config files";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      i3status-rust
      mate.mate-polkit
      networkmanagerapplet
      sway-audio-idle-inhibit swaylock swayidle dbus clipman wl-clipboard xwayland
      avizo
      (import ./sway-regolith/default.nix { inherit pkgs; })
      (import ./regolith-wm-config/default.nix { inherit pkgs; extraConfig = cfg.extraConfig; })
    ];
  };
}
