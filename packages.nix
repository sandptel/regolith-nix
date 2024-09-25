{ system,inputs,config, lib, pkgs, ... }:

with lib;

let
  cfg = config.regolith;
in {
  options.regolith = {
    packages = mkEnableOption "Add regolith packages";
    extraPackages = mkOption {
      type = types.package;
      default = pkgs.hello;
      defaultText = literalExpression "pkgs.hello";
      description = "Add extra packages too add";
    };
    };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      (import ./ilia/default.nix {inherit pkgs;})
      (import ./libtrawldb/default.nix {inherit pkgs;})
      (import ./i3xrocks/default.nix {inherit pkgs;})
      (import ./remontoire/default.nix {inherit pkgs;})
      (import ./rofication/default.nix {inherit pkgs;})
      cfg.extraPackages
      gcc14
      alacritty
      file
      mate.mate-polkit
  ];
    };
  }
