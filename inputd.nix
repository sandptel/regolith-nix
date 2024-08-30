{ system, inputs, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.regolith.inputd;
in {
  options.regolith.inputd = {
    enable = mkEnableOption "Add regolith-inputd binary and services";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (import ./regolith-inputd/default.nix { inherit pkgs; })
    ];

    systemd.user.services.regolith-init-inputd = {
    description = "Start Regolith Input Daemon";

    partOf = [ "graphical-session.target" ];
    wants = [ "gnome-session.target" ];
    after = [ "gnome-session.target" ];

    startLimitIntervalSec = 10;
    startLimitBurst = 5;

    serviceConfig = {
      Type = "exec";
      ExecStart = "/run/current-system/sw/usr/bin/regolith-inputd";
      Restart = "on-failure";
    };
      wantedBy = [ "regolith-wayland.target" ];
  };

  };
}
