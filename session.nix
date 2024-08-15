{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.regolith;
  regolith-session = (import ./regolith-session/default.nix{inherit pkgs;});
in {

options.regolith.session = mkEnableOption{
  default = false;
  description = "Enable Regolith Configs";
};
#adding the binaries for regolith-session
config = mkIf cfg.enable {
  environment.systemPackages = with pkgs; [nix 
      (import ./regolith-session/default.nix {inherit pkgs;})
  ];
  
  environment.etc."xdg/autostart".source = "${regolith-session}/etc/xdg/autostart";
  # environment.etc."xdg/autostart".source = ./regolith-session/etc/xdg/autostart;
  # environment.etc."xdg/autostart".source = ./regolith-session/etc/xdg/autostart;

  environment.variables = {
  EDITOR = "nvim";
  VISUAL = "nvim";
  };

};
}  