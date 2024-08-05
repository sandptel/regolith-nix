{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.regolith.packages;
in {
  options.regolith.packages = {
    enable = mkEnableOption "Add regolith packages";
    package = mkOption {
      type = types.package;
      default = pkgs.hello;
      defaultText = literalExpression "pkgs.hello";
      description = "Add extra packages too add";
    };
    };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (import ./ilia/default.nix {inherit pkgs;})
      (import ./i3xrocks/default.nix {inherit pkgs;})
        (import ./remontoire/default.nix {inherit pkgs;})
        (import ./regolith-powerd/default.nix {inherit pkgs;})
        (import ./regolith-inputd/default.nix {inherit pkgs;})
        (import ./regolith-displayd/default.nix {inherit pkgs;})
        (import ./rofication/default.nix {inherit pkgs;})
        cfg.package
  ];
    };
  }
