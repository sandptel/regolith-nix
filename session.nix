{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.regolith;
in {

options.regolith.session = mkEnableOption{
  default = false;
  description = "Enable Regolith Configs";
};
config = mkIf cfg.enable {
  environment.etc."xdg/autostart".source = ./regolith-session/etc/xdg/autostart;
  # environment.etc."xdg/autostart".source = ./regolith-session/etc/xdg/autostart;
  # environment.etc."xdg/autostart".source = ./regolith-session/etc/xdg/autostart;

  environment.variables = {
  EDITOR = "nvim";
  VISUAL = "nvim";
  };

};
}  