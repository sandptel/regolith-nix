{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.regolith;
in {
  imports= [ ./session.nix ./packages.nix ./sway-regolith.nix ./trawl.nix ./displayd.nix ./powerd.nix ./inputd.nix];  

  options.regolith = {
    enable = mkEnableOption "Enable Regolith";
    };

  config = mkIf cfg.enable {
    environment.pathsToLink = [ "/share" "/etc" "/usr" "/lib" "/bin" "/include"];

  #    environment.systemPackages = with pkgs; [
  #       (import ./sway-regolith/default.nix {inherit pkgs;}) 
  # ];
    regolith.session.enable=true;
    regolith.sway.enable=true;
    regolith.trawl.enable=true;
    regolith.displayd.enable=true;
    regolith.powerd.enable=true;
    regolith.inputd.enable=true;

    # services.displayManager.sessionPackages = [ cfg.package ];
    };
  }