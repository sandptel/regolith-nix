{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.regolith.configs;
in {

options.regolith.session = mkEnableOption{
  default = false;
  description = "Enable Regolith Configs";
};
}

config = mkIf cfg.enable {
  environment.etc."xdg/autostart"".source = "./regolith-session/etc/xdg/autostart";
};

}  