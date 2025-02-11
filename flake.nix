{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ self,nixpkgs }:
      let
        inherit (self) outputs;
        system = "x86_64-linux";
        inherit (nixpkgs) lib;
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # regolith-nix module
        # nixosModules.regolith = import ./regolith.nix;

        # this section can be run using nix run .#<package-name>    --> https://nixos.wiki/wiki/Flakes
        # can perform build checks unsing nix build .#<package-name> --> https://nixos.wiki/wiki/Flakes
        packages."x86_64-linux".ilia = pkgs.callPackage ./packages/ilia.nix{}; # todo--> Stablize --> different icon theme crashes ilia
       
        # todo --> Error :-
        #(process:171187): GLib-GIO-ERROR **: 05:32:45.056: Settings schema 'org.gnome.settings-daemon.plugins.power' is not installed
        packages."x86_64-linux".regolith-powerd = pkgs.callPackage ./packages/regolith-powerd.nix{}; 
        
        #works
        packages."x86_64-linux".regolith-displayd = pkgs.callPackage ./packages/regolith-displayd.nix{}; 
        
        #works
        packages."x86_64-linux".regolith-inputd = pkgs.callPackage ./packages/regolith-inputd.nix{}; 
        
        packages."x86_64-linux".regolith-ftue = pkgs.callPackage ./packages/regolith-ftue.nix{}; 
      
        packages."x86_64-linux".xrescat = pkgs.callPackage ./packages/xrescat.nix{}; 
        
        packages."x86_64-linux".rofication = pkgs.callPackage ./packages/rofication.nix{}; 
        
        packages."x86_64-linux".remontoire = pkgs.callPackage ./packages/remontoire.nix{}; 
        
        packages."x86_64-linux".trawl = pkgs.callPackage ./packages/trawl.nix{}; 
        
        packages."x86_64-linux".regolith-look-extra = pkgs.callPackage ./packages/regolith-look-extra.nix{}; 
        
        
        # packages."x86_64-linux".regolith-look-default = pkgs.callPackage ./packages/regolith-look-default.nix{}; 
        

      };
}