{ system, inputs, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.regolith.powerd;
in {
  options.regolith.powerd = {
    enable = mkEnableOption "Add regolith-powerd binary and services";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (import ./regolith-powerd/default.nix { inherit pkgs; })
    ];

systemd.user.services.regolith-init-powerd = {
    description = "Start Regolith Power Daemon";

    partOf = [ "graphical-session.target" ];
    wants = [ "gnome-session.target" ];
    after = [ "gnome-session.target" ];

    startLimitIntervalSec = 10;
    startLimitBurst = 5;

    serviceConfig = {
      Type = "exec";
      ExecStart = "/run/current-system/sw/usr/bin/regolith-powerd";
      Restart = "on-failure";
    };
      wantedBy = [ "regolith-wayland.target" ];
  };
  



  };
}
