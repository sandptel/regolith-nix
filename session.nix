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
      (import ./regolith-ftue/default.nix {inherit pkgs;})
      (import ./xrescat/default.nix {inherit pkgs;})
      (import ./i3-swap-focus/default.nix {inherit pkgs;})
      (import ./regolith-look-extra/default.nix {inherit pkgs;})
  ];
  environment.etc."xdg/autostart".source = "${regolith-session}/etc/xdg/autostart";
  environment.variables = {
  };

  systemd.user.targets.regolith-x11 = {
    description = "Regolith on X11";
    # defaultDependencies = false;

    wantedBy = [ "gnome-session-initialized.target" ];
    before = [ "gnome-session-initialized.target" ];
    partOf = [ "gnome-session-initialized.target" ];
    requisite = [ "gnome-session-initialized.target" ];
  };

  systemd.user.targets.regolith-wayland = {
    description = "Regolith on Wayland";
    # defaultDependencies = false;

    requisite = [ "gnome-session-initialized.target" ];
    partOf = [ "gnome-session-initialized.target" ];
    before = [ "gnome-session-initialized.target" ];
  };

  systemd.user.services.regolith-wayland = {
    description = "Regolith Session for Sway";

    # On wayland, force a session shutdown
    onFailure = [ "gnome-session-shutdown.target" ];
    # onFailureJobMode = "replace-irreversibly";
    # collectMode = "inactive-or-failed";
    # refuseManualStart = true;
    # refuseManualStop = true;

    after = [ "gnome-session-manager.target" "regolith-wayland.target" ];
    requisite = [ "gnome-session-initialized.target" ];
    partOf = [ "gnome-session-initialized.target" "regolith-wayland.target" ];
    before = [ "gnome-session-initialized.target" ];
    bindsTo = [ "regolith-wayland.target" ];
    requires = [ "trawld.service" ];

    # conditionEnvironment = "XDG_SESSION_TYPE=wayland";

    serviceConfig = {
      Slice = "session.slice";
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "regolith-session-wayland";
      
      # Setup custom environment for session
      EnvironmentFile = "-%h/.config/regolith3/sway/env";
      
      # Unset some environment variables that were set by the shell and won't work now that the shell is gone
      ExecStopPost = [
        "-/bin/sh -c 'test \"$SERVICE_RESULT\" != \"exec-condition\" && systemctl --user unset-environment WAYLAND_DISPLAY DISPLAY XAUTHORITY'"
      ];

      # On wayland, we cannot restart
      Restart = "no";
      # Kill any stubborn child processes after this long
      TimeoutStopSec = 5;

      # Lower down gnome-shell's OOM score to avoid being killed by OOM-killer too early
      OOMScoreAdjust = -1000;
    };
  };

  systemd.user.services.regolith-x11 = {
    description = "Regolith Session for i3";

    # On X11, try to show the GNOME Session Failed screen
    onFailure = [ "gnome-session-failed.target" ];
    # onFailureJobMode = "replace";
    # collectMode = "inactive-or-failed";
    # refuseManualStart = true;
    # refuseManualStop = true;

    after = [ "gnome-session-manager.target" "regolith-x11.target" ];
    requisite = [ "gnome-session-initialized.target" ];
    partOf = [ "gnome-session-initialized.target" "regolith-x11.target" ];
    before = [ "gnome-session-initialized.target" ];
    bindsTo = [ "regolith-x11.target" ];

    # conditionEnvironment = "XDG_SESSION_TYPE=x11";

    # Limit startup frequency more than the default
    startLimitIntervalSec = 15;
    startLimitBurst = 3;

    serviceConfig = {
      Slice = "session.slice";
      Type = "notify";
      NotifyAccess = "all";
      ExecStart = "regolith-session-x11";
      
      # Setup custom environment for session
      EnvironmentFile = "-%h/.config/regolith3/i3/env";

      # On X11 we want to restart on-success and on-failure
      Restart = "always";
      # Do not wait before restarting the shell
      RestartSec = "0ms";
      # Kill any stubborn child processes after this long
      TimeoutStopSec = 5;

      # Lower down gnome-shell's OOM score to avoid being killed by OOM-killer too early
      OOMScoreAdjust = -1000;
    };
  };

};
}  