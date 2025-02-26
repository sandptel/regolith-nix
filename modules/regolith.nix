{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.regolith;
  regolith-session = pkgs.callPackage ./packages/regolith-session.nix {};
  regolith-session-wayland = pkgs.callPackage ./fhs.nix {runScript = "${regolith-session}/bin/regolith-session-wayland";};
in 
{
  options.regolith = {
    enable = mkEnableOption "Enable Regolith";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      regolith-session-wayland
  ];

services.xserver.windowManager.session = [{
      name  = "Regolith Wayland";
      start = ''
        ${regolith-session-wayland}/bin/regolith-session
      '';
    }];
};
}
