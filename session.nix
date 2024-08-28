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
      regolith-session
      (import ./regolith-look-default/default.nix {inherit pkgs;})
  ];
  environment.etc."xdg/autostart".source = "${regolith-session}/etc/xdg/autostart";
  environment.variables = {
  };

};
}  