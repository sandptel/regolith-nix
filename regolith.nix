{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.regolith;
in {
  options.regolith= {
    enable = mkEnableOption "Add regolith";
    };

  config = mkIf cfg.enable {

    import = [./session.nix ./packages.nix];
    
    };
  }
