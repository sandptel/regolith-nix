{
  description = "Packaging Regolith Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = {self, nixpkgs }: 
  let 
  system= "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  in
  {
    nixosModules.regolith = import ./regolith.nix;
    
    devShells.${system}.default = pkgs.mkShell{
      nativeBuildInputs =[
        (import ./ilia/default.nix {inherit pkgs;})
        (import ./i3xrocks/default.nix {inherit pkgs;})
        (import ./remontoire/default.nix {inherit pkgs;})
        (import ./regolith-powerd/default.nix {inherit pkgs;})
        (import ./regolith-inputd/default.nix {inherit pkgs;})
        (import ./regolith-displayd/default.nix {inherit pkgs;})
        (import ./rofication/default.nix {inherit pkgs;})
      ];
    };
    #since only one package can stay in one flake file will need to add them indivisually
    # packages.${system}.ilia= import ./ilia/default.nix{inherit pkgs;};
};
}