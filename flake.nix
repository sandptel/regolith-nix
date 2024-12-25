{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # this version of sway-pkgs is used to build sway-regolith 
    # unstable caused errors in build .... 
    sway-pkgs.url = "github:NixOS/nixpkgs/nixos-24.05"; # todo --> Move to unstable 
  };

  outputs = { self, flake-utils, nixpkgs,sway-pkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        inherit (nixpkgs) lib;
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-sway = sway-pkgs.legacyPackages.${system};
        rpath = lib.makeLibraryPath (with pkgs; [

        ]);
      in
      {
        # holy regolith-nix module 🙏🏼
        nixosModules.regolith = import ./regolith.nix;


        # this section can be run using nix run .#<package-name>    --> https://nixos.wiki/wiki/Flakes
        # can perform build checks unsing nix build .#<package-name> --> https://nixos.wiki/wiki/Flakes
        packages.ilia = pkgs.callPackage ./ilia/default.nix{}; # todo--> Stablize --> different icon theme crashes ilia
        # works with this icon theme --> ??
        packages.trawl = pkgs.callPackage ./trawl/default.nix{}; # todo--> Extra --> binary not found error on <nix run>
        # error: unable to execute '/nix/store/-<Hash>-trawl-3.1/bin/trawl': No such file or directory
        # Reason --> Does not work because trawl has multiple binaries....

        packages.i3-swap-focus = pkgs.callPackage ./i3-swap-focus/default.nix{}; 
        packages.i3status-rs = pkgs.callPackage ./i3status-rs/default.nix{}; #todo --> <nix run> error --> due to pathsToLink = [ /bin /usr /lib] when building shell
        # removed pathsToLink = [ /bin /usr /lib] from i3status-rs/default.nix and might 
        # todo! --> ensure linked paths when creating modules....

        packages.i3xrocks = pkgs.callPackage ./i3xrocks/default.nix{};
        packages.libtrawldb = pkgs.callPackage ./libtrawldb/default.nix{};
        packages.regolith-displayd = pkgs.callPackage ./regolith-displayd/default.nix{};
        packages.regolith-inputd = pkgs.callPackage ./regolith-inputd/default.nix{};
        packages.regolith-powerd = pkgs.callPackage ./regolith-powerd/default.nix{};

        packages.rofication = pkgs.callPackage ./rofication/default.nix{}; # todo --> Permission denied Error on <nix run>
        #might get resolved when running in regolith session....

        packages.sway-regolith = pkgs.callPackage ./sway-regolith/default.nix{inherit pkgs-sway;}; #todo --> move to unstable version 
        # {!done --> <nix run> sway regolith build failure
        # cause --> Change of versions in dependencies due to switch from 24.05--> unstable....}

        packages.regolith-ftue = pkgs.callPackage ./regolith-ftue/default.nix{}; # todo --> <nix run> error --> due to pathsToLink = [ /bin /usr /lib] 
        # might get resolved when running in regolith session....
        # removed pathsToLink = [ /bin /usr /lib] from regolith-ftue/default.nix
        # todo --> ensure linked paths when creating modules....

        packages.remontoire = pkgs.callPackage ./remontoire/default.nix{}; # works perfectly :)
        
        packages.regolith-session = pkgs.callPackage ./regolith-session/default.nix{}; 
        # removed pathsToLink = [ /bin /usr /lib] 
        # todo --> ensure linked paths when creating modules....
        
        packages.regolith-look-default = pkgs.callPackage ./regolith-look-default/default.nix{}; 
        # removed pathsToLink = [ /bin /usr /lib]
        # todo --> ensure linked paths when creating modules....        
        
        packages.regolith-look-extra = pkgs.callPackage ./regolith-look-extra/default.nix{}; 
        # removed pathsToLink = [ /bin /usr /lib] 
        # todo --> ensure linked paths when creating modules.... 

        packages.xrescat = pkgs.callPackage ./xrescat/default.nix{}; # works fine :_)
        
      }
    );
}