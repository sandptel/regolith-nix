{ regolith-session-wayland, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.regolith;
  regolith-environment = pkgs.callPackage ../fhs.nix {};
  # Create a proper session package with the required providedSessions
  regolith-session-package = pkgs.runCommand "regolith-session-wayland" {
    # Define the providedSessions that the error is asking for
    passthru.providedSessions = [ "regolith-session-wayland" ];
  } ''
    mkdir -p $out/share/wayland-sessions
    cat > $out/share/wayland-sessions/regolith-session-wayland.desktop << EOF
    [Desktop Entry]
    Name=Regolith Wayland
    Comment=Regolith Desktop Environment on Wayland
    Exec=${regolith-session-wayland}/bin/regolith-nix-session-wayland
    Type=Application
    EOF
  '';
  regolith-packages = import ../packages { inherit pkgs; };
  
in {
  options.regolith = {
    enable = mkEnableOption "Enable Regolith";
  };
  
  config = mkIf cfg.enable {
    environment.systemPackages = [
      #for dubugging purposes
      regolith-environment
      
      regolith-session-wayland
      # regolith-packages.regolith-session-wayland
      regolith-packages.regolith-session
      regolith-packages.regolith-look-default
      regolith-packages.regolith-look-extra
      regolith-packages.regolith-wm-config
      regolith-packages.regolith-i3status-config
      regolith-packages.regolith-systemd-units
      regolith-packages.regolith-i3status-config
      regolith-packages.regolith-xresources
      regolith-packages.regolith-displayd
      regolith-packages.regolith-inputd
      regolith-packages.regolith-powerd
      regolith-packages.regolith-ftue
      regolith-packages.xrescat
      regolith-packages.rofication
      regolith-packages.remontoire
      regolith-packages.trawl
      regolith-packages.i3xrocks
      regolith-packages.libtrawlb
      regolith-packages.i3-swap-focus
      regolith-packages.regolith-systemd-units
      regolith-packages.regolith-i3status-config
      # regolith-packages.regolith-xresources
    ] ;
    
    # Use the sessionPackages option with our properly formatted session package
    services.displayManager.sessionPackages = [ 
      regolith-session-package
    ];
  };
}