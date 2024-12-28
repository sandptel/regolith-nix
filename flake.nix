{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # this version of sway-pkgs is used to build sway-regolith 
    # unstable caused errors in build .... 
    sway-pkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # todo --> Move to unstable 
  };

  outputs = inputs@{ self,nixpkgs,sway-pkgs }:
      let
        inherit (self) outputs;
        system = "x86_64-linux";
        inherit (nixpkgs) lib;
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-sway = sway-pkgs.legacyPackages.${system};
      in
      {
        # holy regolith-nix module 🙏🏼
        nixosModules.regolith = import ./regolith.nix;

        # this section can be run using nix run .#<package-name>    --> https://nixos.wiki/wiki/Flakes
        # can perform build checks unsing nix build .#<package-name> --> https://nixos.wiki/wiki/Flakes
        packages."x86_64-linux".ilia = pkgs.callPackage ./ilia/default.nix{}; # todo--> Stablize --> different icon theme crashes ilia
        # works with this icon theme --> ??
        packages."x86_64-linux".trawl = pkgs.callPackage ./trawl/default.nix{}; # todo--> Extra --> binary not found error on <nix run>
        # error: unable to execute '/nix/store/-<Hash>-trawl-3.1/bin/trawl': No such file or directory
        # Reason --> Does not work because trawl has multiple binaries....

        packages."x86_64-linux".i3-swap-focus = pkgs.callPackage ./i3-swap-focus/default.nix{}; 
        packages."x86_64-linux".i3status-rs = pkgs.callPackage ./i3status-rs/default.nix{}; #todo --> <nix run> error --> due to pathsToLink = [ /bin /usr /lib] when building shell
        # removed pathsToLink = [ /bin /usr /lib] from i3status-rs/default.nix and might 
        # todo! --> ensure linked paths when creating modules....

        packages."x86_64-linux".i3xrocks = pkgs.callPackage ./i3xrocks/default.nix{};
        packages."x86_64-linux".libtrawldb = pkgs.callPackage ./libtrawldb/default.nix{};
        packages."x86_64-linux".regolith-displayd = pkgs.callPackage ./regolith-displayd/default.nix{};
        packages."x86_64-linux".regolith-inputd = pkgs.callPackage ./regolith-inputd/default.nix{};
        packages."x86_64-linux".regolith-powerd = pkgs.callPackage ./regolith-powerd/default.nix{};

        packages."x86_64-linux".rofication = pkgs.callPackage ./rofication/default.nix{}; # todo --> Permission denied Error on <nix run>
        #might get resolved when running in regolith session....

        packages."x86_64-linux".sway-regolith = pkgs.callPackage ./sway-regolith/default.nix{inherit pkgs-sway;}; #todo --> move to unstable version 
        # {!done --> <nix run> sway regolith build failure
        # cause --> Change of versions in dependencies due to switch from 24.05--> unstable....}

        packages."x86_64-linux".regolith-ftue = pkgs.callPackage ./regolith-ftue/default.nix{}; # todo --> <nix run> error --> due to pathsToLink = [ /bin /usr /lib] 
        # might get resolved when running in regolith session....
        # removed pathsToLink = [ /bin /usr /lib] from regolith-ftue/default.nix
        # todo --> ensure linked paths when creating modules....

        packages."x86_64-linux".remontoire = pkgs.callPackage ./remontoire/default.nix{}; # works perfectly :)
        
        packages."x86_64-linux".regolith-session = pkgs.callPackage ./regolith-session/default.nix{}; 
        # removed pathsToLink = [ /bin /usr /lib] 
        # todo --> ensure linked paths when creating modules....
        
        packages."x86_64-linux".regolith-look-default = pkgs.callPackage ./regolith-look-default/default.nix{}; 
        # removed pathsToLink = [ /bin /usr /lib]
        # todo --> ensure linked paths when creating modules....        
        
        packages."x86_64-linux".regolith-look-extra = pkgs.callPackage ./regolith-look-extra/default.nix{}; 
        # removed pathsToLink = [ /bin /usr /lib] 
        # todo --> ensure linked paths when creating modules.... 

        packages."x86_64-linux".xrescat = pkgs.callPackage ./xrescat/default.nix{}; # works fine :_)
        
        #Build tests for nixosConfiguration
        # this is a sample config template from https://github.com/Misterio77/nix-starter-configs/blob/main/minimal 
        # ***and should not be used with rebuild switch*** 
        nixosConfigurations.testing = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {inherit inputs outputs;};
            modules = [
              # Import the previous configuration.nix we used,
              # so the old configuration file still takes effect
              ./testing/nixos/configuration.nix
            ];
          };
        

        #Build Tests for Homemanager Module # todo --> Make a Home Manager Module 
        # homeConfigurations = {
        # # FIXME replace with your username@hostname
        # "your-username@your-hostname" = home-manager.lib.homeManagerConfiguration {
        # pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        # extraSpecialArgs = {inherit inputs outputs;};
        # # > Our main home-manager configuration file <
        # modules = [./testing/home-manager/home.nix];
        #   };
        # };

        # todo --> Write tests using nixosTests https://blog.thalheim.io/2023/01/08/how-to-use-nixos-testing-framework-with-flakes/
        # nixosTests = {
        #   test1 = {
        #     description = "Test by running sway-regolith";
        #     expression = pkgs.writeScript "test1" ''
        #       if ! ${pkgs.sway-regolith}/bin/sway-regolith --version; then
        #         echo "sway-regolith is not installed";
        #         exit 1;
        #       fi
        #     '';
        #   };
        # };



      };
}