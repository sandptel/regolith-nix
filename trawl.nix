{ system, inputs, config, lib, pkgs, ... }:

with lib;

let
  cfg = config.regolith.trawl;
in {
  options.regolith.trawl = {
    enable = mkEnableOption "Add trawl and trawld.service";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (import ./trawl/default.nix { inherit pkgs; })
    ];

# https://github.com/regolith-linux/trawl/blob/62cf7cf325ab516a3fac9305b3f4a7c96b84b814/debian/trawld.install#L2

  systemd.user.services.trawld = {
    description = "Trawl Configuration Daemon";
    startLimitIntervalSec = 200;
    startLimitBurst = 2;

    serviceConfig = {
      ExecStart = "/run/current-system/sw/usr/bin/trawld";
      Restart = "always";
      RestartSec = 1;
      Type = "dbus";
      BusName = "org.regolith.Trawl";
    };
      wantedBy = [ "default.target" ];
  };
  };
}
