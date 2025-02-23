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
        # Helper to collect all packages
      allPackages = with self.packages.${system}; [
        ilia
        regolith-powerd
        regolith-displayd
        regolith-inputd
        regolith-ftue
        xrescat
        rofication
        remontoire
        trawl
        i3xrocks
        libtrawlb
        regolith-look-extra
        i3status-rs
        sway-regolith
        regolith-session
      ];
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

        packages."x86_64-linux".i3xrocks = pkgs.callPackage ./packages/i3xrocks.nix{}; 

        packages."x86_64-linux".libtrawlb = pkgs.callPackage ./packages/libtrawldb.nix{}; 
        
        packages."x86_64-linux".regolith-look-extra = pkgs.callPackage ./packages/regolith-look-extra.nix{}; 
        
        packages."x86_64-linux".i3status-rs = pkgs.callPackage ./packages/i3status-rs.nix{}; 

        packages."x86_64-linux".sway-regolith = pkgs.callPackage ./sway-regolith/default.nix{}; 

        packages."x86_64-linux".regolith-session = pkgs.callPackage ./packages/regolith-session.nix{}; 

        packages."x86_64-linux".regolith-wm-config = pkgs.callPackage ./packages/regolith-wm-config.nix{}; 

        packages."x86_64-linux".fhs = pkgs.callPackage ./fhs.nix{}; 
        
        packages."x86_64-linux".regolith-look-default = pkgs.callPackage ./packages/regolith-look-default.nix{}; 
        # this runs via --> nix run .#nixosConfigurations.vm.config.system.build.vm
        devShells.${system}.default = let
          fhs = pkgs.callPackage ./fhs.nix {};
        in pkgs.mkShell {
          packages = [ fhs ] ++ allPackages;
          shellHook = ''
            exec ${fhs}/bin/regolith-environment
          '';
        };

        nixosConfigurations.vm = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ pkgs, ... }: {
            # Basic system configuration
            fileSystems."/" = {
              device = "none";
              fsType = "tmpfs";
              options = [ "size=2G" "mode=755" ];
            };

            boot.loader.grub.enable = true;
            boot.loader.grub.devices = [ "nodev" ];

            # VM-specific settings
            virtualisation.vmVariant = {
              virtualisation = {
                memorySize = 4096; # MB
                cores = 4;
              };
            };
            
            # Basic system services
            # services.xserver = {
            #   enable = true;
            #   # displayManager.gdm.enable = true;
            #   # desktopManager.gnome.enable = true;
            # };
            
            # Packages and user configuration
            environment.systemPackages = allPackages;
            
            users.users.demo = {
              isNormalUser = true;
              extraGroups = [ "wheel" ];
              initialPassword = "demo";
            };

            system.stateVersion = "23.11";
          })
        ];
      };
      };
}