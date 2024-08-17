{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.regolith.session;
  regolith-session = (import ./regolith-session/default.nix{inherit pkgs;});
in {

options.regolith.session ={
  enable = mkEnableOption "Add regolith session files";
  description = "Enable Regolith Session";
};
#adding the binaries for regolith-session
config = mkIf cfg.enable {
  
  #regolith-session-common 
  environment.systemPackages = with pkgs; [
      (import ./regolith-session/default.nix {inherit pkgs;})
  ];
  
  environment.etc."xdg/autostart".source = "${regolith-session}/etc/xdg/autostart";
  # environment.etc."xdg/autostart".source = ./regolith-session/etc/xdg/autostart;
  # environment.etc."xdg/autostart".source = ./regolith-session/etc/xdg/autostart;
  environment.variables = {
  # RSC = "${regolith-session}/lib/regolith/regolith-session-common.sh";
  # # ISUAL = "kvim";
  };

  #regolith-sway-root-config https://github.com/regolith-linux/regolith-wm-config/blob/a1a77b9d08661d30b90c44aef6350e34c5b2ffb0/debian/regolith-sway-root-config.install#L1
  environment.etc."regolith".source = ./regolith-wm-config/etc/regolith;



};
}  