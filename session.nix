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
  
  environment.pathsToLink = [ "/share" "/etc" "/usr" "/lib" "/bin" "/include"];

  #regolith-session-common 
  environment.systemPackages = with pkgs; [
      i3status-rust
      mate.mate-polkit
      networkmanagerapplet
      sway-audio-idle-inhibit
      avizo
      (import ./regolith-session/default.nix {inherit pkgs;})
      (import ./regolith-look-default/default.nix {inherit pkgs;})
  ];
  
  # environment.etc."xdg/autostart".source = "${regolith-session}/etc/xdg/autostart";

  environment.variables = {
  # RSC = "${regolith-session}/lib/regolith/regolith-session-common.sh";
  # # ISUAL = "kvim";
  };


  #systemd services
  # environment.etc."systemd/user/gnome-session@regolith-wayland.target.d".source = "${regolith-session}/lib/systemd/user/gnome-session@regolith-wayland.target.d";
  # environment.etc."systemd/user/gnome-session@regolith-x11.target.d".source = "./regolith-session/usr/lib/systemd/user/gnome-session@regolith-x11.target.d";

  #regolith-sway-root-config https://github.com/regolith-linux/regolith-wm-config/blob/a1a77b9d08661d30b90c44aef6350e34c5b2ffb0/debian/regolith-sway-root-config.install#L1
  # environment.etc."regolith".source = ./regolith-wm-config/etc/regolith;

};
}  