# Building Packages 
Installing Nix
```
sh <(curl -L https://nixos.org/nix/install) --no-daemon
 . ~/.nix-profile/etc/profile.d/nix.sh
export NIX_CONFIG="experimental-features = nix-command flakes"
```

## Install Regolith using flake
Add regolith.url to the inputs and import its NixosModule
```
{
  description = "A system config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    homeManager={
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      };  
     regolith.url = "path:/home/roronoa/Documents/reg/regolith-nix";   
  };

  outputs = { self,nixpkgs,home-manager, ... }@inputs: 
  let 
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosConfigurations."<systemname>" = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit system inputs;};
      modules = [
        inputs.regolith.nixosModules.regolith
      ];
    };
    
  };
}

```

In your config file add the following lines to enable regolith and extraConfig to add your own custom config lines to sway

```
regolith.enable=true;
regolith.sway.extraConfig= ''
# Bind Alt+Enter to open Alacritty
bindsym Mod1+Return exec alacritty'';
```

This will enable add all the required packages along with a displaymanager session.

Use `regolith-session-wayland` command to envoke the session.

## To create a development shell with the following packages..

```nix develop github:sandptel/regolith-nix```

